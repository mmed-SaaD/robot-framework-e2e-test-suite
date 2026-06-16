*** Settings ***
Library    SeleniumLibrary
Resource    ../../resources/keywords/security/security_keywords.resource
Resource    ../../resources/variables/security/security_payloads.resource
Resource    ../../resources/keywords/global_keywords.resource

Suite Setup    Create ZAP Session

*** Test Cases ***
#SEC-ZAP-001
Perform Automated Spidering To Discover Application Endpoints
    [Tags]    security    zap    spider
    Assert Automated Spidering Process Starting

#SEC-ZAP-002
Execute Passive Security Analysis
    [Tags]    security    zap    spider
    Wait Until ZAP Passive Scan Is Completed

#SEC-ZAP-003
Execute Active Vulnerability Scanning 
    [Tags]    security    zap    spider
    Assert Active Scanning Process Starting
    
#SEC-ZAP-004
Generate HTML Security Reports 
    [Tags]    security    zap    report
    Generate HTML Report For ZAP Findings

#SEC-ZAP-005
Fail The Pipeline When Critical Vulnerabilities Are Detected
    [Tags]    security    zap
    Assert No Blocking ZAP Alerts Present