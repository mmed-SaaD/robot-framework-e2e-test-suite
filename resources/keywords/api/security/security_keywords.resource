*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../../api/auth/auth_keywords.resource

*** Keywords ***
Session setup
    Create Session    owasp security    ${BASE_URL}
    ${token}    ${None}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary        
    ...    Authorization=Bearer ${token}
    RETURN    ${token}    ${headers}

Assert SQL Injection Payload In Login Is Detected
    ${email}=    Set Variable    ' OR 1=1 --
    ${token}    ${None}=    Assert Valid Login Returns Authentication Token    ${email}
    Should Be Empty    ${token}    msg=Login process must fail and detect sql injection attempt

Assert SQL Injection Payload In Search Is Handled Safely
    Create Session    owasp security    ${BASE_URL}
    ${payloads}=    Create List    
    ...    ' OR 1=1--    
    ...    ' UNION SELECT * FROM Users--    
    ...    "; DROP TABLE Users-- 
    FOR    ${payload}    IN    @{payloads}
        ${response}=    GET On Session    owasp security    /rest/products/search    params=${payload}   expected_status=any
        Should Not Be Equal As Integers    ${response.status_code}    500
        ${data}=    Get Length    ${response.json()}[data]
        Should Be Equal As Integers    ${data}    0
    END

Assert XSS Payload In Search Or Feedback Is Handled Safely
    ${token}    ${headers}=    Session setup
    ${response}=    GET On Session    owasp security    /rest/captcha    headers=${headers}    expected_status=200
    ${captcha_details}=    Set Variable    ${response.json()}
    ${captchaID}=    Set Variable    ${captcha_details}[captchaId]
    ${captcha_answer}=    Set Variable    ${captcha_details}[answer]
    ${body}=    Create Dictionary    
    ...    captchaId=${captchaID}
    ...    captcha=${captcha_answer}
    ...    comment=<script>alert('Helloooo !');</script>
    ...    rating=3
    ${response}=    POST On Session    owasp security    /api/Feedbacks    headers=${headers}    json=${body}    expected_status=any
    Should Not Contain    ${response.json()}[data][comment]    <script>
    Should Not Contain    ${response.json()}[data][comment]    </script>
    Should Not Contain    ${response.json()}[data][comment]    alert
    Should Not Be Equal As Integers    ${response.status_code}    500

Assert API Response Does Not Expose Password Hashes Or Sensitive Tokens
    ${token}    ${headers}=    Session setup
    ${response}=    GET On Session    owasp security    /api/Users    headers=${headers}    expected_status=200
    Should Not Be Equal As Integers    ${response.status_code}    500

    ${response_text}=    Set Variable    ${response.text}

    Should Not Be Equal As Integers    ${response.status_code}    500

    ${response_text}=    Set Variable    ${response.text}

    Should Not Contain Any
    ...    ${response_text}
    ...    password
    ...    passwordHash
    ...    hash
    ...    resetToken
    ...    totpSecret
    ...    secret
    ...    privateKey
    ...    authentication
    ...    token

    
    

