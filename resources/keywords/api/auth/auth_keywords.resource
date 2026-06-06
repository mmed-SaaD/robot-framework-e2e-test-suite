*** Settings ***
Library    RequestsLibrary
Library    Collections
Variables    ../../../../core/utils/env_loader.py

*** Keywords ***
Login Process
    [Arguments]    ${email}=${EMPTY}    ${password}=${EMPTY}
    Create Session    owasp auth    url=${BASE_URL}
    ${body}=    Create Dictionary
    ...    email=${email}    password=${password}

    ${response}=    POST On Session   owasp auth    /rest/user/login    json=${body}    expected_status=any
    RETURN     ${response}
    
Assert Valid Login Returns Authentication Token
    [Arguments]    ${email}=${VALID_EMAIL} 
    ${response}=    Login Process    ${email}   ${VALID_PASSWORD}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Not Be Empty    ${response.json()}

    Dictionary Should Contain Key    ${response.json()}    authentication
    Should Not Be Empty    ${response.json()}[authentication][token]

    RETURN    ${response.json()}[authentication][token]    ${response.json()}[authentication][bid]  

Assert Login With Invalid Email Is Rejected
    ${response}=    Login Process    ${INVALID_EMAIL}    ${VALID_PASSWORD}

    Should Be Equal As Integers    ${response.status_code}    401
    ${error_message}=    Set Variable    ${response.text}
    Should Contain    ${error_message}    Invalid email or password.

Assert Login With Invalid Password Is Rejected
    ${response}=    Login Process    ${VALID_EMAIL}    ${INVALID_PASSWORD}

    Should Be Equal As Integers    ${response.status_code}    401
    ${error_message}=    Set Variable    ${response.text}
    Should Contain    ${error_message}    Invalid email or password.

Assert Login With Empty Request Is Rejected
    Create Session    owasp auth    url=${BASE_URL}

    ${response}=    POST On Session   owasp auth    /rest/user/login    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    401
    ${error_message}=    Set Variable    ${response.text}
    Should Contain    ${error_message}    Invalid email or password.

Assert Login With Missing Email Field Is Rejected
    Create Session    owasp auth    url=${BASE_URL}

    ${body}=    Create Dictionary
    ...    password=${VALID_PASSWORD}

    ${response}=    POST On Session
    ...    owasp auth
    ...    /rest/user/login
    ...    json=${body}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    401
    ${error_message}=    Set Variable    ${response.text}
    Should Contain    ${error_message}    Invalid email or password.

Assert Login With Missing Password Field Is Rejected
    Create Session    owasp auth    url=${BASE_URL}

    ${body}=    Create Dictionary
    ...    email=${VALID_EMAIL}

    ${response}=    POST On Session
    ...    owasp auth
    ...    /rest/user/login
    ...    json=${body}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    401
    ${error_message}=    Set Variable    ${response.text}
    Should Contain    ${error_message}    Invalid email or password.

Assert Authenticated Request Succeeds With Valid Token
    ${response}=    Login Process    ${VALID_EMAIL}    ${VALID_PASSWORD}
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${response.json()}[authentication][token]
    Create Session    owasp api    ${BASE_URL}
    ${response}=    GET On Session    owasp api    /rest/wallet/balance    headers=${headers}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    data

Assert Authenticated Request Fails Without Token
    Create Session    owasp api    ${BASE_URL}
    ${response}=    GET On Session    owasp api    /rest/wallet/balance    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401
    Dictionary Should Not Contain Key    ${response.headers}    authorization

Assert Invalid JWT Token Triggers Server Error
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.fakepayload.invalidsignature
    Create Session    owasp api    ${BASE_URL}
    ${response}=    GET On Session    owasp api    /rest/wallet/balance    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    500
    Should Contain    ${response.text}    Unexpected token
    Should Contain    ${response.text}    is not valid JSON
    Log    Invalid JWT token returned 500 instead of 401    WARN

Assert Authenticated Request Fails With Malformed Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer 213herrgefjje&df
    Create Session    owasp api    ${BASE_URL}
    ${response}=    GET On Session    owasp api    /rest/wallet/balance    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401
    Dictionary Should Not Contain Key    ${response.json()}    data
