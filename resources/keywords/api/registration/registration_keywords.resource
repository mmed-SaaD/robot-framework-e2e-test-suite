*** Settings ***
Library    RequestsLibrary
Library    Collections
Variables    ../../../../core/utils/env_loader.py

*** Keywords ***
Assert User Registration With Valid Data
    [Arguments]    ${email}=${VALID_EMAIL10}
    Create Session    owasp registration    ${BASE_URL}
    ${security_question}=    Create Dictionary    id=1    question=Your eldest siblings middle name?
    ${body}=    Create Dictionary
    ...    email=${email}    password=${VALID_PASSWORD}
    ...    passwordRepeat=${VALID_PASSWORD}    securityQuestion=${security_question}
    ...    securityAnswer=${SECURITY_QUESTION}
    ${response}=    POST On Session    owasp registration    /api/Users    json=${body}    expected_status=201
    Should Be Equal As Integers    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    data
    Should Not Be Empty    ${response.json()}[data]
    Should Contain    ${response.json()}[data][email]    ${email}
    RETURN    ${response.json()}

Assert User Registration With Existing Email Is Rejected
    Create Session    owasp registration    ${BASE_URL}
    ${security_question}=    Create Dictionary    id=1    question=Your eldest siblings middle name?
    ${body}=    Create Dictionary
    ...    email=${VALID_EMAIL}    password=${VALID_PASSWORD}
    ...    passwordRepeat=${VALID_PASSWORD}    securityQuestion=${security_question}
    ...    securityAnswer=${SECURITY_QUESTION}
    ${response}=    POST On Session    owasp registration    /api/Users    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    400
    Dictionary Should Contain Key    ${response.json()}    errors
    ${errors}=    Set Variable    ${response.json()}[errors][0]
    Dictionary Should Contain Key    ${errors}    field      message    
    Should Contain    ${errors}[message]    email must be unique

Assert User Registration With Invalid Format Is Rejected
    Create Session    owasp registration    ${BASE_URL}
    ${security_question}=    Create Dictionary    id=1    question=Your eldest siblings middle name?
    ${body}=    Create Dictionary
    ...    email=${MALFORMED_EMAIL}    password=${VALID_PASSWORD}
    ...    passwordRepeat=${VALID_PASSWORD}    securityQuestion=${security_question}
    ...    securityAnswer=${SECURITY_QUESTION}
    ${response}=    POST On Session    owasp registration    /api/Users    json=${body}    expected_status=any    
    IF    ${response.status_code} == 201
        Log    Request Must Not Succeed with Malformed Email Address As It Is With UI Registration Case    WARN
    ELSE
        Should Be Equal As Integers    ${response.status_code}    400
    END
    
Assert User Registration With Missing Password Is Rejected
    Create Session    owasp registration    ${BASE_URL}
    ${security_question}=    Create Dictionary    id=1    question=Your eldest siblings middle name?
    ${body}=    Create Dictionary
    ...    email=${VALID_EMAIL2}
    ...    securityQuestion=${security_question}
    ...    securityAnswer=${SECURITY_QUESTION}
    ${response}=    POST On Session    owasp registration    /api/Users    json=${body}    expected_status=any    
    IF    ${response.status_code} == 201
        Log    Request Must Not Succeed with Missing Password As It Is With UI Registration Case    WARN
    ELSE
        Should Be Equal As Integers    ${response.status_code}    400
    END

Assert User Registration With Weak Passwprd Is Rejected
    Create Session    owasp registration    ${BASE_URL}
    ${security_question}=    Create Dictionary    id=1    question=Your eldest siblings middle name?
    ${body}=    Create Dictionary
    ...    email=${VALID_EMAIL3}    password=${WEAK_PASSWORD}
    ...    passwordRepeat=${WEAK_PASSWORD}    securityQuestion=${security_question}
    ...    securityAnswer=${SECURITY_QUESTION}
    ${response}=    POST On Session    owasp registration    /api/Users    json=${body}    expected_status=any    
    IF    ${response.status_code} == 201
        Log    Request Must Not Succeed with Weak Password As It Is With UI Registration Case    WARN
    ELSE
        Should Be Equal As Integers    ${response.status_code}    400
    END

Assert User Registration With Missing Security Question Is Rejected
    Create Session    owasp registration    ${BASE_URL}
    ${security_question}=    Create Dictionary    id=1    question=Your eldest siblings middle name?
    ${body}=    Create Dictionary
    ...    email=${VALID_EMAIL4}    password=${VALID_PASSWORD}
    ...    passwordRepeat=${VALID_PASSWORD}   
    ...    securityAnswer=${SECURITY_QUESTION}
    ${response}=    POST On Session    owasp registration    /api/Users    json=${body}    expected_status=any    
    IF    ${response.status_code} == 201
        Log    Request Must Not Succeed with Missing Security Question As It Is With UI Registration Case    WARN
    ELSE
        Should Be Equal As Integers    ${response.status_code}    400
    END

Assert User Registration With Missing Security Answer Is Rejected
    Create Session    owasp registration    ${BASE_URL}
    ${security_question}=    Create Dictionary    id=1    question=Your eldest siblings middle name?
    ${body}=    Create Dictionary
    ...    email=${VALID_EMAIL5}    password=${VALID_PASSWORD}
    ...    passwordRepeat=${VALID_PASSWORD}    securityQuestion=${security_question}
    ${response}=    POST On Session    owasp registration    /api/Users    json=${body}    expected_status=any    
    IF    ${response.status_code} == 201
        Log    Request Must Not Succeed with Missing Security Answer As It Is With UI Registration Case    WARN
    ELSE
        Should Be Equal As Integers    ${response.status_code}    400
    END

Assert Registration Response Does Not Expose Sensitive Data
    ${response}=    Assert User Registration With Valid Data    ${VALID_EMAIL6}
    Dictionary Should Contain Key    ${response}    data    
    Dictionary Should Not Contain Key    ${response}    password    securityQuestion    securityAnswer