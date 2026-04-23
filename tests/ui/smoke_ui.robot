*** Settings ***
Resource    ../../resources/keywords/keywords.resource
Test Setup  Open Browser To Login Page
Test Teardown  Close Browser Session

*** Test Cases ***
Valid User Can Login
    [Tags]    smoke    ui    login
    Login With Valid Credentials
    User Should Be Logged In