*** Settings ***
Library    SeleniumLibrary
Variables    ../../../../core/utils/env_loader.py
Resource   ../../../variables/variables.resource
Resource   ../../../variables/auth/auth_variables.resource
Resource   ../../../locators/smoke/home_page.resource
Resource    ../../../keywords/global_keywords.resource
Resource    ../auth/auth_keywords.resource

*** Keywords ***
Handle Banner If Exists
    ${visible}=    Run Keyword And Return Status    
    ...    Wait Until Element Is Visible
    ...    ${banner}
    ...    5s
    IF    ${visible}
        Click Element    ${dismiss_banner_button}
    END

Page Title Should Be Correct
    Title Should Be    ${SUT_NAME}

Assert Page Loaded
    Handle Banner If Exists

Assert Juice List IS Visible
    Wait Until Page Contains Element    ${list_of_products}    180s
    ${count}=     Get Element Count    ${list_of_products}
    Should Be True    ${count} > 0

Assert Menu Opens
    Assert Page Loaded
    Click Element    ${menu_button}
    Wait Until Element Is Visible    ${side_navbar}

Assert Basket Icon Is Visible
    Assert Page Loaded
    ${TEST_STATUS}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${basket_icon}    10s
    IF    ${TEST_STATUS}
            RETURN
    ELSE
            ${Login_Status}=    Run Keyword And Return Status     Valid Log In
            IF     ${Login_Status}
                Wait Until Element Is Visible    ${basket_icon}    10s
            ELSE
                Fail    msg=Invalid Login
            END
    END

Login Page Opens
    Go to    ${LOGIN_URL}
    Wait Until Element Is Visible    ${login_form_container}    




    
    
