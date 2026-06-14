*** Settings ***
Library    SeleniumLibrary
Resource    ../../../locators/navigation/navigation.resource
Resource    ../../../locators/smoke/home_page.resource
Resource    ../user_account/user_account_keywords.resource
Resource    ../basket/basket_keywords.resource
Resource    ../smoke/smoke_keywords.resource
Resource    ../../global_keywords.resource
Resource    ../auth/auth_keywords.resource

*** Keywords ***
Pretest Build
    Open Browser To Main Page
    Valid Log In
    Close Cookies Message

Assert Menu Opens And Closes
    Assert Menu Opens
    Click Element    ${outside_navbar_content}
    Wait Until Element Is Not Visible    ${side_navbar}    
    
Assert Browser Back Button Works Correctly
    Assert Basket Opens
    Go Back
    Page Should Contain    All Products
    Element Should Be Visible    ${menu_button}

Assert Page Refresh Does Not Break State
    Assert Basket Opens
    Reload Page
    ${welcome_banner}=    Run Keyword And Return Status    Page Should Contain    Welcome to OWASP Juice Shop!
    IF    ${welcome_banner}
        Click Button    ${close_welcome_banner}
    END
    Page Should Contain    Your Basket
    Assert Account Page Opens
    Reload Page
    Page Should Contain    User Profile

Assert Support Chat Opens
    Assert Menu Opens
    Wait Until Element Is Visible    ${support_chat}
    Click Element    ${support_chat}
    Page Should Contain    Support Chat

Assert Support Chat Feature Is Functional
    [Arguments]    ${payload}
    Assert Support Chat Opens
    Press Keys    ${chat_support_message_input}    ${payload}    
    Press Keys    ${chat_support_message_input}    ENTER
    ${alert_is_present}=    Run Keyword And Return Status    Alert Should Be Present
    Should Be Equal    ${alert_is_present}    ${False}
