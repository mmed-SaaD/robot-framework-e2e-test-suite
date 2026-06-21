*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    RequestsLibrary
Resource    ../resources/keywords/ui/products/products_keywords.resource
Resource    ../ui/navigation/navigation_keywords.resource
Resource    ../ui/user_account/user_account_keywords.resource
Resource    ../../variables/security/security_payloads.resource
Resource    ../../variables/security/security_variables.resource
Resource    ../ui/address_management/address_management_keywords.resource
Resource    ../../locators/basket/basket.resource
Resource    ../api/auth/auth_keywords.resource
Resource    ../../locators/security/security.resource
Variables    ../../../core/utils/env_loader.py

*** Keywords ***
Test Setup
    Open Browser To Main Page
    Valid Log In
    Close Welcome Banner

Create ZAP Session
    Create Directory    ${CURDIR}/${REPORT_DIR}
    Create Session    owasp zap    ${ZAP_URL}

Close Welcome Banner
    ${welcome_banner}=    Run Keyword And Return Status    Page Should Contain    Welcome to OWASP Juice Shop!
    IF    ${welcome_banner}
        Click Button    ${close_welcome_banner}
        Click Element    ${search_icon}
        Wait Until Element Is Visible    ${search_input}
    END

Assert No JS Alert Is Triggered
    [Arguments]    ${XSS_SCRIPT}    ${xss_type}
    Search Product    ${XSS_SCRIPT}
    ${alert_is_present}=    Run Keyword And Return Status    Alert Should Be Present
    IF    ${alert_is_present}
        Capture Security Evidence    ${xss_type}
    END
    
    Should Be Equal    ${alert_is_present}    ${False}    msg=Possible XSS Vulnerability : Alert Has Been detected !



Assert Stored XSS Is Not Effective
    [Arguments]    ${payload}
    #For This test, we will be targetting BOT chat, username and address creation to store XSS payload
    Close Welcome Banner
    #PART1
    Assert Support Chat Feature Is Functional    ${payload}
    #PART2
    Assert Username Is Changed    ${payload}
    Click Element        ${from_account_to_home_button}
    Close Welcome Banner
    #PART 3
    Assert Valid Address Added    ${payload}
    Click Button    ${to_homepage_button}
    Assert Saved Addresses Page Opens
    ${alert_is_present}=    Run Keyword And Return Status    Alert Should Be Present
    Should Not Be True    ${alert_is_present}    msg=Stored XSS Vulnerability Detected in address creation process ! 

Assert User Enumeration Vulnerability Exists
    Create Session    owasp bac    ${BASE_URL}
    ${token}    ${None}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}
    ${response}=    GET On Session    owasp bac    /api/Users    headers=${headers}    expected_status=any
    IF    ${response.status_code} == 200
        ${fetched_records}=    Set Variable    ${response.json()}[data]   
        Should Not Be Empty    ${fetched_records}
        Dictionary Should Contain Key    ${fetched_records}[0]    email
        Dictionary Should Contain Key    ${fetched_records}[0]    role
        #Isolate admin account credentails
        FOR    ${record}    IN    @{fetched_records}
            ${is_admin}=    Run Keyword And Return Status    Should Contain    ${record}[email]    admin
            IF    ${is_admin}
                Log    Admin email recoverd : ${record}[email]    WARN
            END
        END
    END
    Should Be Equal As Integers    ${response.status_code}    200

Assert Unauthorized Users Cannot Access Other User's Resources
    # We will try two cases : 
    # 1)_ Try to recover payment cards of admin account
    Create Session    owasp bac    ${BASE_URL}
    ${token}    ${None}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}
    ${body}=    Create Dictionary    UserId=1
    ${response}=    GET On Session    owasp bac    /api/Cards    json=${body}    headers=${headers}    expected_status=any
    IF    ${response.status_code} == 200
        ${fetched_payment_cards}=    Set Variable    ${response.json()}[data]
        FOR    ${payment_card}    IN    @{fetched_payment_cards}
            Should Not Be Equal As Integers    ${payment_card}[UserId]    ${body}[UserId]
        END
    END
    # 3)_ Temper with user A token by changing the id to match the admin's account id and try fetching the admin's payment cards again 
    #below we will swipe the legitimate token with the tampered one:
    ${token}=    Set Variable    ${tampered_token}
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}
    ${response}=    GET On Session    owasp bac    /api/Cards    json=${body}    headers=${headers}    expected_status=401

Assert Direct Object Reference Manipulation Does Not Exspose Unauthorized Data
    Create Session    owasp bac    ${BASE_URL}
    ${admin_id}=    Set Variable    1
    ${admin_basket_id}=    Set Variable    1
    ${token}    ${None}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}
    #What we will do is try 
    ${response}=    GET On Session    owasp bac    /rest/Basket/1    headers=${headers}    expected_status=any
    IF    ${response.status_code} == 200
        ${fetched_basket}=    Set Variable    ${response.json()}[data]
        Should Not Be Equal As Integers   ${fetched_basket}[UserId]    ${admin_id}    msg=Vulnerability Found : Admin Basket Accessed !
        Should Not Be Equal As Integers   ${fetched_basket}[id]    ${admin_basket_id}    msg=Vulnerability Found : Admin Basket Accessed !
    END
    
Assert Relative Path Traversal Sequences Are Blocked
    ${payloads}=    Create List
    ...    /ftp/../
    ...    /ftp/../../
    ...    /ftp/../../../
    Create Session    owasp path traversal    ${BASE_URL}
    #Below is a request to a valid endpoint, then we will try to escape it by moving to parent directory
    ${response}=    GET On Session    owasp path traversal    /ftp    expected_status=200
    FOR    ${payload}    IN    @{payloads}
       ${response}=    GET On Session    owasp path traversal    ${payload}    expected_status=any
       Should Not Contain    ${response.text}    routes
       Should Not Contain    ${response.text}    node_modules
       Should Not Contain    ${response.text}    root:
       Should Not Contain    ${response.text}    server.js
    END

Assert Sensitive System Files Cannot Be Accessed
    ${payloads}=    Create List
    ...    /ftp/../
    ...    /ftp/../../
    ...    /ftp/../../../
    Create Session    owasp path traversal    ${BASE_URL}
    #Below is a request to a valid endpoint, then we will try to escape it by moving to parent directory
    ${response}=    GET On Session    owasp path traversal    /ftp    expected_status=200
    FOR    ${payload}    IN    @{payloads}
       ${response}=    GET On Session    owasp path traversal    ${payload}    expected_status=any
        Should Not Contain    ${response.text}    root:
        Should Not Contain    ${response.text}    daemon:
        Should Not Contain    ${response.text}    /bin/bash
        Should Not Contain    ${response.text}    SECRET
        Should Not Contain    ${response.text}    PASSWORD
    END

Assert Encoded Path Traversal Sequences Are Blocked
    ${payloads}=    Create List
    ...    /ftp/%2e%2e/
    ...    /ftp/%2e%2e%2f
    ...    /ftp/%2e%2e%2f%2e%2e%2f
    ...    /ftp/..%2f
    ...    /ftp/..%2f..%2f
    Create Session    owasp path traversal    ${BASE_URL}
    #Below is a request to a valid endpoint, then we will try to escape it by moving to parent directory
    ${response}=    GET On Session    owasp path traversal    /ftp    expected_status=200
    FOR    ${payload}    IN    @{payloads}
       ${response}=    GET On Session    owasp path traversal    ${payload}    expected_status=403
       Should Not Contain    ${response.text}    routes
       Should Not Contain    ${response.text}    root:
       Should Not Contain    ${response.text}    node_modules
       Should Not Contain    ${response.text}    server.js
    END

Assert Executable Files Are Rejected
    ${file_name}=    Set Variable    payload.php
    Assert Account Page Opens
    Choose File    ${img_upload}    ${EXECDIR}/core/utils/security_payloads/${file_name}
    Click Button    ${img_upload_button}
    Page Should Contain    Error: Illegal file type

Assert Malicious File Extensions Are Blocked
    [Arguments]    ${file}

    Assert Account Page Opens

    ${payload}=    Normalize Path    ${EXECDIR}/core/utils/security_payloads/${file}
    File Should Exist    ${payload}

    Wait Until Element Is Visible    ${img_upload}    10s
    Choose File    ${img_upload}    ${payload}

    Wait Until Element Is Visible    ${img_upload_button}    10s
    Click Button    ${img_upload_button}

    ${illegal_type}=    Run Keyword And Return Status
    ...    Wait Until Page Contains    Error: Illegal file type    5s

    ${too_large}=    Run Keyword And Return Status
    ...    Wait Until Page Contains    Error: File too large    5s

    Should Be True    ${illegal_type} or ${too_large}    msg=Malicious file was not rejected correctly.
    
Start ZAP
    [Arguments]    ${target_url}=${BASE_URL}
    ${params}=    Create Dictionary    url=${target_url}    recurse=true
    ${response}=    GET On Session    owasp zap    /JSON/spider/action/scan/    params=${params}    expected_status=200
    ${scan_id}=    Set Variable    ${response.json()}[scan]
    Log    ZAP Scan started ! Scan id : ${scan_id}
    RETURN    ${scan_id}

Wait Until ZAP Scan Is Completed
    [Arguments]    ${scan_id}
    FOR    ${index}    IN RANGE    ${ZAP_MAX_WAIT}
        ${params}=    Create Dictionary    scanId=${scan_id}
        ${response}=    GET On Session    owasp zap    /JSON/spider/view/status/    params=${params}    expected_status=200

        ${status}=    Convert To Integer    ${response.json()}[status]
        Log    Spider Scan Progress : ${status}%    

        IF    ${response.json()}[status] == 100
            Log    Spider Scan Completed !
            RETURN
        END
        Sleep    ${SLEEP_TIME}
    END
    Fail    Spider scan did not finish within timeout
    
Wait Until ZAP Passive Scan Is Completed
    FOR    ${index}    IN RANGE    ${ZAP_MAX_WAIT}
        ${response}=    GET On Session    owasp zap    /JSON/pscan/view/recordsToScan/    expected_status=200
        ${remaining}=    Convert To Integer    ${response.json()}[recordsToScan]

        IF    ${remaining} == 0
            Log    Passive Scan Completed !
            RETURN
        END
        Log    ${remaining} remaining records to scan !
        Sleep    ${SLEEP_TIME}
    END
    Fail    Passive scan did not finish within timeout
    
Assert Target Exists In ZAP Site Tree
    ${response}=    GET On Session    owasp zap    /JSON/core/view/sites/    expected_status=200
    Log    ${response.text}
    ${sites}=    Set Variable    ${response.json()}[sites]
    Should Contain    ${sites}    ${BASE_URL}

Start ZAP Active Scan
    [Arguments]    ${target_url}=${BASE_URL}
    Assert Target Exists In ZAP Site Tree
    ${params}=    Create Dictionary    url=${target_url}    recurse=false
    ${response}=    GET On Session    owasp zap    /JSON/ascan/action/scan/    params=${params}    expected_status=200

    ${scan_id}=    Set Variable    ${response.json()}[scan]
    Log    Active Vulnerability Scan Started ! scan id : ${scan_id}
    RETURN    ${scan_id}
    
Wait Until Active Vulnerability Scan Is Completed
    [Arguments]    ${scan_id}
    FOR    ${index}    IN RANGE    ${ZAP_MAX_WAIT}
        ${params}=    Create Dictionary    scanId=${scan_id}
        ${response}=    GET On Session    owasp zap    /JSON/ascan/view/status/    params=${params}    expected_status=200

        ${status}=    Convert To Integer    ${response.json()}[status]

    IF    ${status} == 100
        Log    Active Vulnerability Scan is completed !
        RETURN
    END
    Log    Active Vulnerability Scan Progress : ${status}%
    Sleep    ${SLEEP_TIME}
    END
    Fail    Active scan did not finish within timeout
    
Generate HTML Report For ZAP Findings
    ${response}=    Get On Session    owasp zap    /OTHER/core/other/htmlreport/    expected_status=200
    Create File    ${CURDIR}/${REPORT_DIR}/${REPORT_FILE}    ${response.text}
    File Should Exist    ${CURDIR}/${REPORT_DIR}/${REPORT_FILE}
    log    Report Generated : ${CURDIR}/${REPORT_DIR}/${REPORT_FILE}

Assert No Blocking ZAP Alerts Present
    ${params}=    Create Dictionary    baseurl=${BASE_URL}
    ${response}=    GET On Session    owasp zap    /JSON/core/view/alerts    params=${params}    expected_status=200
    ${alerts}=    Set Variable    ${response.json()}[alerts]
    ${blocking_alerts}=    Create List

    FOR    ${alert}    IN    @{alerts}
        ${risk}=    Set Variable    ${alert}[risk]
        ${name}=    Set Variable    ${alert}[alert]
        ${url}=    Set Variable    ${alert}[url]
        
        IF    '${risk}' in @{BLOCKING_RISKS}
            ${message}=    Set Variable    ${risk} - ${name} - ${url}
            Append To List    ${blocking_alerts}    ${message}
        END
    END
    ${count}=    Get Length    ${blocking_alerts}

    IF    ${count} > 0
        Log Many    @{blocking_alerts}
        Fail    ZAP found ${count} blocking security alert(s). Check the HTML report.
    END

    Log    No blocking ZAP alerts found.

    

Assert Active Scanning Process Starting
    ${scan_id}=    Start ZAP Active Scan
    Wait Until Active Vulnerability Scan Is Completed    ${scan_id}
    
Assert Automated Spidering Process Starting
    ${scan_id}=    Start ZAP
    Wait Until ZAP Scan Is Completed    ${scan_id}

Capture Security Evidence
    [Arguments]    ${name}
    Capture Page Screenshot    ../../results/security/screenshots/${name}.png