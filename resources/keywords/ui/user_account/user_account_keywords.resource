*** Settings ***
Library    SeleniumLibrary
Variables    ../../../../core/utils/env_loader.py
Resource    ../../../locators/user_account/user_account.resource
Resource    ../../../locators/auth/auth.resource
Resource    ../../global_keywords.resource
Resource    ../auth/auth_keywords.resource

*** Keywords ***
Pretest Build
    Open Browser To Main Page
    Valid Log In
    Close Cookies Message

Open Change Password Page
    Click Button    ${navbar_account}
    Wait Until Element Is Visible    ${open_privacy_&_security_button}
    Mouse Over    ${open_privacy_&_security_button}
    Wait Until Element Is Visible    ${go_to_change_password_button}
    Click Button    ${go_to_change_password_button}
    Page Should Contain    Change Password   

Assert Account Page Opens
    Click Button    ${navbar_account}
    Wait Until Element Is Visible    ${open_account_button}
    Click Button    ${open_account_button}
    Page Should Contain    User Profile
    Page Should Contain    Email

Assert Password Is Changed
    Open Change Password Page
    Wait Until Initial Snackbar Disappears
    Input Text    ${current_password_input}    ${VALID_PASSWORD}
    Input Text    ${new_password_input}    ${NEW_PASSWORD}
    Input Text    ${repeat_new_password_input}    ${NEW_PASSWORD}
    Capture Page Screenshot    change_pass.png
    Click Button    ${change_password_button}
    Wait Until Page Contains    Your password was successfully changed.
    Click Button    ${navbar_account}
    Click Button    ${logout_button}
    Valid Log In    password=${NEW_PASSWORD}

################################### Reset the old password ###################################################
    Open Change Password Page
    Input Text    ${current_password_input}    ${NEW_PASSWORD}
    Input Text    ${new_password_input}    ${VALID_PASSWORD}
    Input Text    ${repeat_new_password_input}    ${VALID_PASSWORD}
    Click Button    ${change_password_button}
    Wait Until Page Contains    Your password was successfully changed.
    Click Button    ${navbar_account}
    Click Button    ${logout_button}
    Valid Log In    password=${VALID_PASSWORD}

Assert Password Doesnt Change With Wrong Current Password
    Open Change Password Page
    Input Text    ${current_password_input}    ${INVALID_PASSWORD}
    Input Text    ${new_password_input}    ${NEW_PASSWORD}
    Input Text    ${repeat_new_password_input}    ${NEW_PASSWORD}
    Click Button    ${change_password_button}
    Page Should Contain    Current password is not correct.

Assert Username Is Changed
    [Arguments]    ${username}    
    Assert Account Page Opens
    Press Keys    ${username_input}    ${username}
    Press Keys    ${username_input}    ENTER
    ${text}=    Get Text    ${username_display_field}
    ${alert_is_present}=    Run Keyword And Return Status    Alert Should Be Present
    Should Be Equal    ${alert_is_present}    ${False}
    