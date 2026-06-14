*** Settings ***
Resource    ../../resources/keywords/ui/user_account/user_account_keywords.resource
Resource    ../../resources/keywords/global_keywords.resource
Test Setup    user_account_keywords.Pretest Build
Test Teardown    Close All Browsers

*** Test Cases ***
#UI-ACC-001  UI-ACC-002
Open Account Page
    [Tags]    regression    ui    account
    Assert Account Page Opens

# UI-ACC-003
Change Password
    [Tags]    regression    ui    account    auth
    Assert Password Is Changed

#UI-ACC-004
Change Password With Wrong Current Password
    [Tags]    regression    ui    account    negative
    Assert Password Doesnt Change With Wrong Current Password

#UI-ACC-005
Change Username
    [Tags]    regression    ui    account
    Assert Username Is Changed    brook
