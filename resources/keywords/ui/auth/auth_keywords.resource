*** Settings ***
Library    SeleniumLibrary
Variables    ../../../../core/utils/env_loader.py
Resource    ../../../variables/variables.resource
Resource    ../../../variables/auth/auth_variables.resource
Resource    ../smoke/smoke_keywords.resource

*** Keywords ***
Handle Welcome Banner
    ${welcome_banner_displayed}=    Run Keyword And Return Status    Page Should Contain    Welcome to OWASP Juice Shop!
    IF    ${welcome_banner_displayed}
        Click Button    ${close_welcome_banner}
    END

Valid Log In
    [Arguments]    ${email}=${VALID_EMAIL}    ${password}=${VALID_PASSWORD}
    Login Page Opens
    Handle Welcome Banner
    Input Text    ${email_input}    text=${email}
    Input Password    ${password_input}    password=${password}
    Click Button    ${login_button}
    ${Login_failed}=    Run Keyword And Return Status    Element Should Be Visible    ${login_err}
    IF    ${Login_failed}
        Fail    ${login_err_message}
    END
    Wait Until Element Is Visible    ${navbar_account}

Invalid Email Log In Case
    Login Page Opens
    Handle Welcome Banner
    Input Text    ${email_input}    text=${invalid_email}
    Input Password    ${password_input}    password=${VALID_PASSWORD}
    Click Button    ${login_button}
    Wait Until Element Is Visible   ${login_err}    2s

Invalid Password Log In Case
    Login Page Opens
    Handle Welcome Banner
    Input Text    ${email_input}    text=${VALID_EMAIL}
    Input Password    ${password_input}    password=${invalid_password}
    Click Button    ${login_button}
    Wait Until Element Is Visible   ${login_err}    2s

Empty Credentials Log In Case
    Login Page Opens
    Handle Welcome Banner
    Input Text    ${email_input}    text=
    Input Password    ${password_input}    password=
    Click Button    ${show_password_button}
    Wait Until Element Contains    ${empty_email_err}    ${empty_email_err_message}
    Wait Until Element Contains    ${empty_password_err}    ${empty_password_err_message}

Badly Formatted Email log IN Case
    Login Page Opens
    Handle Welcome Banner
    Input Text    ${email_input}    text=${badly_formatted_email}
    Input Password    ${password_input}    password=${invalid_password}
    Click Button    ${login_button}
    Wait Until Element Is Visible   ${login_err}    2s

Logout Process Successfull
    Login Page Opens
    Handle Welcome Banner
    Valid Log In
    Click Button    ${navbar_account}
    Click Button    ${logout_button}
    Wait Until Element Is Not Visible    ${basket_icon}    30s
    Click Button    ${navbar_account}
    Wait Until Element Is Visible    ${navbarLoginButton}    30s

Assert Session Persists After Reload
    Login Page Opens
    Handle Welcome Banner
    Valid Log In
    Assert Page Loaded
    Reload Page
    Assert Basket Icon Is Visible

Protected Pages Are Unaccessible After Log Out
    Logout Process Successfull
    Go To    http://127.0.0.1:3000/#/basket
    ${basket_list_is_visible}=    Run Keyword And Return Status
    ...        Wait Until Element Is Visible   ${basket_container}    2s
    IF    not ${basket_list_is_visible}
        RETURN
    ELSE
        Fail    Security Defect : Basket Page should not be directly accessible after logout
    END    
