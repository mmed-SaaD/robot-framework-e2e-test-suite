*** Settings ***
Library    SeleniumLibrary
Resource   ../variables/variables.resource

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window

Close Browser Session
    Close Browser

Login With Valid Credentials
    Input Text       id:user-name    ${VALID_USER}
    Input Text       id:password     ${VALID_PASS}
    Click Button     id:login-button

User Should Be Logged In
    Wait Until Page Contains Element    id:shopping_cart_container    10s