*** Settings ***
Library    RequestsLibrary
Library    Collections
Variables    ../../../../core/utils/env_loader.py

*** Keywords ***
Assert API Is Reachable
    Create Session    owasp smoke    url=${BASE_URL}
    ${response}=    GET On Session    owasp smoke    /api/products

    Should Be Equal As Integers    ${response.status_code}    200
    Should Not Be Empty    ${response.json()}

Assert Login Endpoint Is Reachable    
    Create Session    owasp smoke    url=${BASE_URL}
    ${body}=    Create Dictionary
    ...    email=${VALID_EMAIL}    password=${VALID_PASSWORD}

    ${response}=    POST On Session   owasp smoke    /rest/user/login    ${body}

    Should Be Equal As Integers    ${response.status_code}    200
    Should Not Be Empty    ${response.json()}

    Dictionary Should Contain Key    ${response.json()}    authentication
    Should Not Be Empty    ${response.json()}[authentication][token]
    RETURN    ${response.json()}[authentication][token]

Assert Basket Endpoint Is Reachable For Authenticated User
    ${authentication_token}=        Assert Login Endpoint Is Reachable
    Create Session    owasp smoke    url=${BASE_URL}
    ${headers}=    Create Dictionary    
    ...    authorization=Bearer ${authentication_token}
    ${response}=    GET On Session    owasp smoke    /rest/basket/1    headers=${headers}

    Should Be Equal As Integers    ${response.status_code}    200
    Should Not Be Empty    ${response.json()}

Assert Invalid Endpoint Returns Controlled Error Message
    Create Session    owasp smoke    url=${BASE_URL}
    ${response}=    GET On Session    owasp smoke    /rest/invalid/endpoint    expected_status=any 
    ${error_message}=    Set Variable    ${response.text}
    Should Contain    ${error_message}    Unexpected path: /rest/invalid/endpoint