*** Settings ***
Library    SeleniumLibrary
Resource    ../../resources/keywords/security/security_keywords.resource
Resource    ../../resources/keywords/global_keywords.resource

Test Setup    Test Setup
Test Teardown    Close All Browsers


*** Test Cases ***
#SEC-UPLOAD-001
Executable Files Are Rejected 
    [Tags]    security    file_upload
    Assert Executable Files Are Rejected


#SEC-UPLOAD-002
Malicious file extensions are blocked
    [Tags]    security    file_upload
    [Template]    Assert Malicious File Extensions Are Blocked
    payload.php
    payload.PHP
    payload.exe
    payload.jsp
    payload.sh
