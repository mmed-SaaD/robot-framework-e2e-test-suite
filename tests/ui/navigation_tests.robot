*** Settings ***
Resource    ../../resources/keywords/navigation/navigation_keywords.resource
Resource    ../../resources/keywords/global_keywords.resource
Test Setup    navigation_keywords.Pretest Build
Test Teardown    Close All Browsers

*** Test Cases ***
#UI-NAV-001
Menu Opens And Closes
    [Tags]    regression    ui    navigation 
    Assert Menu Opens And Closes

#UI-NAV-006
Browser Back Button Works Correctly
    [Tags]    regression    ui    navigation
    Assert Browser Back Button Works Correctly

#UI-NAV-007
Page Refresh Does Not Break Current State
    [Tags]    regression    ui    navigation    session
    Assert Page Refresh Does Not Break State