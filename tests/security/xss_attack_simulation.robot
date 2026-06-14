*** Settings ***
Documentation    Offensive Security Tests For the SUT against XSS attacks
Library    SeleniumLibrary
Resource    ../../resources/keywords/security/security_keywords.resource
Resource    ../../resources/keywords/ui/products/products_keywords.resource
Resource    ../../resources/variables/security/security_payloads.resource
Resource    ../../resources/keywords/global_keywords.resource

Test Setup    Test Setup
Test Teardown    Close All Browsers

*** Test Cases ***
#SEC-XSS-001
Reflected XSS Payloads Are Not Executed In User Input Fields
    [Tags]    security    xss
    [Template]    Assert No JS Alert Is Triggered
    ${XSS_SCRIPT_ALERT}    xss_script_alert
    ${XSS_IMG_ONEERROR}    xss_img_onerror
    ${XSS_SVG_ONLOAD}    xss_vsg_onload
    ${XSS_JAVASCRIPT_URL}    xss_javascript_url
    
#SEC-XSS-002
Stored XSS Payloads Are Safely Handled After Persistence  
    [Tags]    security    xss
    [Template]    Assert Stored XSS Is Not Effective
    ${XSS_SCRIPT_ALERT}  
    ${XSS_IMG_ONEERROR} 
    ${XSS_SVG_ONLOAD}  
    ${XSS_JAVASCRIPT_URL}    