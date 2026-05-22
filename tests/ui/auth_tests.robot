*** Settings ***
Resource    ../../resources/keywords/global_keywords.resource
Resource    ../../resources/keywords/auth/auth_keywords.resource
Test Setup  Open Browser To Main Page
Test Teardown  Close Browser Session

*** Test Cases ***
#UI-AUTH-001 
Valid Log In
    [Tags]    regression    ui    auth    critical
    Valid Log In

#UI-AUTH-002
Invalid Email Log In
    [Tags]    regression    ui    auth    negative
    Invalid Email Log In Case

#UI-AUTH-003
Invalid Password Log In
    [Tags]    regression    ui    auth    negative
    Invalid Password Log In Case

#UI-AUTH-004
Empty Log In
    [Tags]    regression    ui    auth    negative
    Empty Credentials Log In Case

#UI-AUTH-005
Badly Formatted Email Log In
    [Tags]    regression    ui    auth    negative
    Badly Formatted Email log IN Case

#UI-AUTH-006
Logout Process Is Successfull
    [Tags]    regression    ui    auth
    Logout Process Successfull

#UI-AUTH-007
Session Persists After Refresh
    [Tags]    regression    ui    auth    session
    Assert Session Persists After Reload

#UI-AUTH-008
Protected Pages Unaccessible After Logout
    [Tags]    regression    ui    auth    security-ui
    Protected Pages Are Unaccessible After Log Out