*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../../api/checkout/checkout_keywords.resource
Resource    ../../api/basket/basket_keywords.resource
Variables    ../../../../core/utils/env_loader.py

*** Keywords ***
Session setup
    Create Session    owasp feedback    ${BASE_URL}
    ${token}    ${None}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary        
    ...    Authorization=Bearer ${token}
    RETURN    ${token}    ${headers}

Assert Valid Feedback Submission
    ${token}    ${headers}=    Session setup
    ${response}=    GET On Session    owasp feedback    /api/Feedbacks    headers=${headers}    expected_status=200
    ${list_of_feedbacks}=    Set Variable    ${response.json()}[data]
    ${previous_feedbacks_count}=    Get Length    ${list_of_feedbacks}
    ${response}=    GET On Session    owasp feedback    /rest/captcha    headers=${headers}    expected_status=200
    ${captcha_details}=    Set Variable    ${response.json()}
    ${captchaID}=    Set Variable    ${captcha_details}[captchaId]
    ${captcha_answer}=    Set Variable    ${captcha_details}[answer]
    ${body}=    Create Dictionary    
    ...    captchaId=${captchaID}
    ...    captcha=${captcha_answer}
    ...    comment=Not Bad Actually, i may even consider coming back with my children another time !   
    ...    rating=3
    ${response}=    POST On Session    owasp feedback    /api/Feedbacks    headers=${headers}    json=${body}    expected_status=201
    Should Not Be Empty    ${response.json()}[data]
    Should Contain    ${response.json()}[data][comment]    ${body}[comment]
    Should Be Equal As Strings    ${response.json()}[status]    success

    ${response}=    GET On Session    owasp feedback    /api/Feedbacks    headers=${headers}    expected_status=200
    ${list_of_feedbacks}=    Set Variable    ${response.json()}[data]
    ${current_feedbacks_count}=    Get Length    ${list_of_feedbacks}
    ${expected_feedbacks_count}=    Evaluate    ${previous_feedbacks_count} + 1
    Should Be Equal As Integers    ${current_feedbacks_count}    ${expected_feedbacks_count}

Assert Feedback With Empty Comment Is Rejected
    ${token}    ${headers}=    Session setup

    ${response}=    GET On Session    owasp feedback    /rest/captcha    headers=${headers}    expected_status=200
    ${captcha_details}=    Set Variable    ${response.json()}
    ${captchaID}=    Set Variable    ${captcha_details}[captchaId]
    ${captcha}=    Set Variable    ${captcha_details}[captcha]
    ${captcha_answer}=    Set Variable    ${captcha_details}[answer]

    ${body}=    Create Dictionary    
    ...    captchaId=${captchaID}
    ...    captcha=${captcha_answer}
    ...    rating=3
    ${response}=    POST On Session    owasp feedback    /api/Feedbacks    headers=${headers}    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    400    msg=Comment field is missing, the feedback must not be created

Assert Feedback With Invalid Rating Is Rejected
    ${token}    ${headers}=    Session setup

    ${response}=    GET On Session    owasp feedback    /rest/captcha    headers=${headers}    expected_status=200
    ${captcha_details}=    Set Variable    ${response.json()}
    ${captchaID}=    Set Variable    ${captcha_details}[captchaId]
    ${captcha}=    Set Variable    ${captcha_details}[captcha]
    ${captcha_answer}=    Set Variable    ${captcha_details}[answer]

    ${body}=    Create Dictionary    
    ...    captchaId=${captchaID}
    ...    captcha=${captcha_answer}
    ...    comment=Not Bad Actually, i may even consider coming back with my children another time !   
    ...    rating=11
    ${response}=    POST On Session    owasp feedback    /api/Feedbacks    headers=${headers}    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    400    msg=Rating field is invalid, the feedback must not be created

Assert Feedback Without Captcha Answer Is Rejected
    ${token}    ${headers}=    Session setup

    ${response}=    GET On Session    owasp feedback    /rest/captcha    headers=${headers}    expected_status=200
    ${captcha_details}=    Set Variable    ${response.json()}
    ${captchaID}=    Set Variable    ${captcha_details}[captchaId]
    ${captcha}=    Set Variable    ${captcha_details}[captcha]
    ${captcha_answer}=    Set Variable    ${captcha_details}[answer]

    ${body}=    Create Dictionary    
    ...    captchaId=${captchaID}
    ...    comment=Not Bad Actually, i may even consider coming back with my children another time !   
    ...    rating=4
    ${response}=    POST On Session    owasp feedback    /api/Feedbacks    headers=${headers}    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401    msg=Captcha answer is missing! the feedback must not be created

Assert Feedback With Script Payload Is Safely Handled
    ${token}    ${headers}=    Session setup

    ${response}=    GET On Session    owasp feedback    /rest/captcha    headers=${headers}    expected_status=200
    ${captcha_details}=    Set Variable    ${response.json()}
    ${captchaID}=    Set Variable    ${captcha_details}[captchaId]
    ${captcha_answer}=    Set Variable    ${captcha_details}[answer]
    ${body}=    Create Dictionary    
    ...    captchaId=${captchaID}
    ...    captcha=${captcha_answer}
    ...    comment=<script>alert("xss")</script>
    ...    rating=3
    ${response}=    POST On Session    owasp feedback    /api/Feedbacks    headers=${headers}    json=${body}    expected_status=any
    Should Not Be Empty    ${response.json()}[data]
    Should Not Contain    ${response.json()}[data][comment]    <script>
    Should Not Contain    ${response.json()}[data][comment]    alert("xss")
    Should Not Contain    ${response.json()}[data][comment]    </script>
    Should Be True    ${response.status_code} in [400,422]    msg=Script Payload is safely handled, but the status is still success !

Assert Feedback Endpoint Does Not Expose Internal Server Errors
    ${token}    ${headers}=    Session setup

    ${response}=    GET On Session    owasp feedback    /rest/captcha    headers=${headers}    expected_status=200
    ${captcha_details}=    Set Variable    ${response.json()}
    ${captchaID}=    Set Variable    ${captcha_details}[captchaId]
    ${captcha_answer}=    Set Variable    ${captcha_details}[answer]
    ${body}=    Create Dictionary    
    ...    comment=<script>alert("xss")</script>
    ...    rating=3
    ${response}=    POST On Session    owasp feedback    /api/Feedbacks    headers=${headers}    json=${body}    expected_status=500
    ${response_text}=    Set Variable    ${response.text}
    Should Not Contain Any    ${response_text}    SQLiteQueryGenerator.getWhereConditions    
    ...    SQLiteQueryGenerator.whereItemsQuery    SQLiteQueryGenerator.selectQuery      /juice-shop    
    ...    /routes    msg=Sensitive server information is being exposed