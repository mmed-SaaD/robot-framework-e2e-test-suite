*** Settings ***
Resource    ../../resources/keywords/registration/registration_keywords.resource
Resource    ../../resources/keywords/global_keywords.resource
Test Setup  Open Browser To Main Page
Test Teardown  Close Browser Session

*** Test Cases ***
#UI-REG-001
Open Registration Page
    [Tags]    regression    ui    registration
    Assert Registration Page Opens

#UI-REG-002
Registration With Valid Data
    [Tags]    regression    ui    registration    critical 
    Create New Customer Account With Valid Data

#UI-REG-003 
Registration With Empty Email
    [Tags]    regression    ui    registration    negative
    Create New Customer Account With Empty Email

#UI-REG-004 
Registration With Invalid Email Format
    [Tags]    regression    ui    registration    negative
    Create New Customer Account With Invalid Email Format

#UI-REG-005
Registration With Empty Password
    [Tags]    regression    ui    registration    negative
    Create New Customer Account With Empty Password

#UI-REG-006 
Registration With Weak Password
    [Tags]    regression    ui    registration    negative
    Create New Customer Account With Weak Password

#UI-REG-007
Registration With Existing Email
    [Tags]    regression    ui    registration    negative
    Create New Customer Account With Existing Email

#NB : UI-REG-008 is included in all the other test cases !

#UI-REG-009
Registration With Unmatched Passwords
    [Tags]    regression    ui    registration    negative
    Create New Customer Account With Unmatched Passwords