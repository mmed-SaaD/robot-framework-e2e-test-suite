*** Settings ***
Library     RequestsLibrary
Library    Collections
Resource    ../auth/auth_keywords.resource
Resource    ../../../variables/negative/negative_variables.resource
Variables    ../../../../core/utils/env_loader.py


*** Keywords ***
Session Setup
    Create Session    owasp negative tests    ${BASE_URL}
    ${token}    ${basket_id}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    RETURN    ${headers}    ${basket_id}

Assert Endpoint Rejects Unsupported HTTP Method
    ${headers}    ${None}=    Session Setup
    ${response}=    DELETE On Session    owasp negative tests   /api/Products    headers=${headers}    expected_status=any
    Should Be True    ${response.status_code} in [400, 404, 405]    
    ...    msg=Unsupported HTTP Method should be correctly handled, not with status code : ${response.status_code}
    Should Not Contain    ${response.json()}[status]    success

Assert Endpoint Rejects Malformed JSON Body
    [Arguments]    ${email}=${VALID_EMAIL10}
    ${headers}    ${None}=    Session Setup
    Set To Dictionary    ${headers}    Content-Type=application/json

    ${body}=    Catenate    SEPARATOR=
    ...    {email:"${email}",
    ...    "password":"${VALID_PASSWORD}",
    ...    "passwordRepeat"="${VALID_PASSWORD}",
    ...    "securityAnswer":"${SECURITY_QUESTION}"
    

    ${response}=    POST On Session
    ...    owasp negative tests
    ...    /api/Users
    ...    headers=${headers}
    ...    data=${body}
    ...    expected_status=any

    Should Not Be Equal As Integers
    ...    ${response.status_code}
    ...    201
    ...    msg=Malformed JSON body should not be accepted*

Assert Endpoint Rejects Missing Required Headers
    Create Session    owasp negative tests    ${BASE_URL}
    ${token}    ${basket_id}=    Assert Valid Login Returns Authentication Token
    #We will not include authorization header in this case, authorization is a required header
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    GET On Session    owasp negative tests    /rest/basket/${basket_id}    headers=${headers}    expected_status=401
    ${response_html}=    Set Variable    ${response.text}
    Should Contain    ${response_html}    UnauthorizedError: No Authorization header was found

Assert Endpoint Handles Very Long Input Safely
    ${headers}    ${None}=    Session Setup
    ${response}=    GET On Session    owasp negative tests    /rest/captcha    headers=${headers}    expected_status=200
    ${captcha_details}=    Set Variable    ${response.json()}
    ${captchaID}=    Set Variable    ${captcha_details}[captchaId]
    ${captcha_answer}=    Set Variable    ${captcha_details}[answer]
    ${body}=    Create Dictionary    
    ...    captchaId=${captchaID}
    ...    captcha=${captcha_answer}
    ...    comment=${extremely_large_comment}
    ...    rating=3
    ${response}=    POST On Session    owasp negative tests    /api/Feedbacks    headers=${headers}    json=${body}    expected_status=any
    Should Be True    ${response.status_code} in [200,201]

Assert Endpoint Handles Special Characters Safely
    ${headers}    ${None}=    Session Setup
    ${response}=    GET On Session    owasp negative tests    /rest/captcha    headers=${headers}    expected_status=200
    ${captcha_details}=    Set Variable    ${response.json()}
    ${captchaID}=    Set Variable    ${captcha_details}[captchaId]
    ${captcha_answer}=    Set Variable    ${captcha_details}[answer]
    ${body}=    Create Dictionary    
    ...    captchaId=${captchaID}
    ...    captcha=${captcha_answer}
    ...    comment=${comment_with_special_characters1}
    ...    rating=3
    ${response}=    POST On Session    owasp negative tests    /api/Feedbacks    headers=${headers}    json=${body}    expected_status=any
    Should Be True    ${response.status_code} in [200,201]
    Should Not Contain    ${response.json()}[data][comment]    <script>
    Should Not Contain    ${response.json()}[data][comment]    </script>
    Should Not Contain    ${response.json()}[data][comment]    alert

Assert Endpoint Handles Null Values Safely
    [Arguments]    ${email}=${VALID_EMAIL10}
    ${headers}=    Session Setup
    ${security_question}=    Create Dictionary    id=1    question=Your eldest siblings middle name?
    ${body}=    Create Dictionary
    ...    email=${None}    password=${VALID_PASSWORD}
    ...    passwordRepeat=${VALID_PASSWORD}    securityQuestion=${security_question}
    ...    securityAnswer=${SECURITY_QUESTION}
    ${response}=    POST On Session    owasp negative tests    /api/Users    json=${body}    expected_status=any   
    Should Not Be Equal As Integers    ${response.status_code}    500    msg=Null values must not trigger error ${response.status_code}
    Should Not Be Equal As Integers    ${response.status_code}    201
    Should Not Contain    ${response.text}    TypeError: Cannot read properties of null 

Assert Endpoint Handles Wrong Data Types Safely
    ${headers}    ${basket_id}=    Session Setup
    ${response}=    GET On Session    owasp negative tests    /rest/basket/${basket_id}    expected_status=200    headers=${headers}
    ${basket_products}=    Set Variable    ${response.json()}[data]
    ${basket_items}=    Set Variable    ${response.json()}[data][Products][0][BasketItem]
    Dictionary Should Contain Key    ${basket_items}    quantity
    ${previous_product_quantity}=    Set Variable    ${basket_items}[quantity]
    ${new_product_quantity}=    Evaluate    ${previous_product_quantity} + 1
    ${body}=    Create Dictionary    quantity=invalid_value
    ${response}=     PUT On Session    owasp negative tests    /api/BasketItems/${basket_items}[id]      json=${body}   headers=${headers}    expected_status=any
    Should Be True    ${response.status_code} in [400 , 422]
    Should Not Be Equal As Integers    ${response.status_code}    500

Assert Endpoint Returns controlled Error For Unknown Resource ID
    ${headers}    ${None}=    Session Setup
    ${response}=    GET On Session    owasp negative tests   /api/Products/99999999999999999   headers=${headers}    expected_status=404
    Should Be True    ${response.status_code} in [400, 404, 405]    
    ...    msg=Unsupported HTTP Method should be correctly handled, not with status code : ${response.status_code}