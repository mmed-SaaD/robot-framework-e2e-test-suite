*** Settings ***
Resource    ../../resources/keywords/global_keywords.resource
Resource    ../../resources/keywords/ui/smoke/smoke_keywords.resource
Test Setup  Open Browser To Main Page
Test Teardown  Close Browser Session

*** Test Cases ***
#UI-SMOKE-001
App Opens Successfully
    [Tags]    smoke    ui
    Page Title Should Be Correct

#UI-SMOKE-002
Page Loads Without Blocking Banner
    [Tags]    smoke    ui
    Handle Banner If Exists
    Page Title Should Be Correct

#UI-SMOKE-003
Product List Should Be Visible
    [Tags]    smoke    ui    products
    Handle Banner If Exists
    Assert Juice List IS Visible

#UI-SMOKE-004
Navigation Menu Is Working
    [Tags]    smoke    ui    navigation
    ASSERT MENU OPENS

#UI-SMOKE-005
Basket Icon Is Visible
    [Tags]    smoke    ui    basket
    Assert Basket Icon Is Visible

#UI-SMOKE-006
Login Page Opens
    [Tags]    smoke    ui    auth
    Login Page Opens

    

    
