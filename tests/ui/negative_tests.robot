*** Settings ***
Resource    ../../resources/keywords/ui/negative/negative_keywords.resource
Resource    ../../resources/keywords/global_keywords.resource
Test Setup    Pretest Build
Test Teardown    Close All Browsers

*** Test Cases ***
#UI-NEG-001
Invalid Route Redirects Safely 
    [Tags]    regression    ui    negative    routing
    Assert Invalid Route Redirects Safely

#UI-NEG-002 
Direct Access To Basket While Logged Out
    [Tags]    regression    ui    negative    auth
    Assert Access To Basket Denied If Logged Out

#UI-NEG-003
Direct Access To Checkout While Logged Out
    [Tags]    regression    ui    negative    auth    checkout
    Assert Access Denied To Checkout If Logged Out