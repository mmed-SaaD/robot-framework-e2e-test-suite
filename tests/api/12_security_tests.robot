*** Settings ***
Resource    ../../resources/keywords/api/security/security_keywords.resource

*** Test Cases ***
#API-SEC-001
SQL Injection Payload In Login Is Detected
    [Tags]    regression    api    security    sqli
    Assert SQL Injection Payload In Login Is Detected

#API-SEC-002
SQL Injection Payload In Search Is Handled Safely
    [Tags]    regression    api    security    sqli
    Assert SQL Injection Payload In Search Is Handled Safely

#API-SEC-003
XSS Payload In Search Or Feedback Is Handled Safely
    [Tags]    regression    api    security    xss
    Assert XSS Payload In Search Or Feedback Is Handled Safely

#API-SEC-004
API Response Does Not Expose Password Hashes Or Sensitive Tokens
    [Tags]    regression    api    security    data-exposure
    Assert API Response Does Not Expose Password Hashes Or Sensitive Tokens