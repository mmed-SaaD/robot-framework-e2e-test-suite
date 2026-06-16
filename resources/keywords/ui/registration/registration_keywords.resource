*** Settings ***
Library     SeleniumLibrary
Variables    ../../../../core/utils/env_loader.py
Resource    ../../../locators/registration/registration.resource
Resource    ../../../variables/registration/registration_variables.resource
Resource    ../../global_keywords.resource

*** Keywords ***
Assert Registration Page Opens
    Go To    ${REGISTRATION_URL}
    Close Welcome Banner
    Wait Until Element Is Visible    ${registration_form}
    Wait Until Initial Snackbar Disappears

Create New Customer Account With Valid Data
    Assert Registration Page Opens
    Input Text    ${email_input}        ${VALID_EMAIL}
    Input Password    ${password_input}        ${VALID_PASSWORD}
    Input Password    ${repeated_password_input}      ${VALID_PASSWORD}
    Click Element    ${registration_security_question_list}
    Wait Until Element Is Visible     ${security_question_option} 
    Click Element     ${security_question_option}
    Input Text    ${security_question_answer_input}     ${SECURITY_QUESTION}
    Element Should Be Enabled    ${registration_button}
    Sleep    3s
    Click Button       ${registration_button} 

Create New Customer Account With Empty Email
    Assert Registration Page Opens
    Input Text    ${email_input}    text=
    Input Password    ${password_input}        ${VALID_PASSWORD}
    Input Password    ${repeated_password_input}      ${VALID_PASSWORD}
    Click Element    ${registration_security_question_list}
    Wait Until Element Is Visible     ${security_question_option} 
    Click Element     ${security_question_option}
    Input Text    ${security_question_answer_input}     ${SECURITY_QUESTION}
    Element Should Be Visible    ${empty_email_err}
    Element Should Be Disabled       ${registration_button} 

Create New Customer Account With Invalid Email Format
    Assert Registration Page Opens
    Input Text    ${email_input}    ${invalid_email_format}
    Input Password    ${password_input}        ${VALID_PASSWORD}
    Input Password    ${repeated_password_input}      ${VALID_PASSWORD}
    Click Element    ${registration_security_question_list}
    Wait Until Element Is Visible     ${security_question_option} 
    Click Element     ${security_question_option}
    Input Text    ${security_question_answer_input}     ${SECURITY_QUESTION}
    Element Should Be Visible    ${invalid_email_err}
    Element Should Be Disabled       ${registration_button} 

Create New Customer Account With Empty Password
    Assert Registration Page Opens
    Input Text    ${email_input}    ${VALID_EMAIL}
    Input Password    ${password_input}    password=
    Input Password    ${repeated_password_input}    password=
    Click Element    ${registration_security_question_list}
    Wait Until Element Is Visible     ${security_question_option} 
    Click Element     ${security_question_option}
    Input Text    ${security_question_answer_input}     ${SECURITY_QUESTION}
    Element Should Be Visible    ${empty_password_err}
    Element Should Be Visible    ${empty_repeated_password_err}
    Element Should Be Disabled       ${registration_button} 

Create New Customer Account With Weak Password
    Assert Registration Page Opens
    Input Text    ${email_input}    ${VALID_EMAIL}
    Input Password    ${password_input}    password=${weak_password}
    Input Password    ${repeated_password_input}    password=${weak_password}
    Click Element    ${registration_security_question_list}
    Wait Until Element Is Visible     ${security_question_option} 
    Click Element     ${security_question_option}
    Input Text    ${security_question_answer_input}     ${SECURITY_QUESTION}
    Element Should Be Visible    ${weak_password_err}
    Element Should Be Disabled       ${registration_button} 

Create New Customer Account With Existing Email
    Assert Registration Page Opens
    Input Text    ${email_input}        ${VALID_EMAIL}
    Input Password    ${password_input}        ${VALID_PASSWORD}
    Input Password    ${repeated_password_input}      ${VALID_PASSWORD}
    Click Element    ${registration_security_question_list}
    Wait Until Element Is Visible     ${security_question_option} 
    Click Element     ${security_question_option}
    Input Text    ${security_question_answer_input}     ${SECURITY_QUESTION}
    Element Should Be Enabled    ${registration_button}
    Sleep    3s
    Click Button       ${registration_button} 
    Wait Until Element Is Visible    ${unique_email_info}    5s

Create New Customer Account With Unmatched Passwords
    Assert Registration Page Opens
    Input Text    ${email_input}        ${VALID_EMAIL}
    Input Password    ${password_input}        ${VALID_PASSWORD}
    Input Password    ${repeated_password_input}      ${weak_password}
    Click Element    ${registration_security_question_list}
    Wait Until Element Is Visible     ${security_question_option} 
    Click Element     ${security_question_option}
    Input Text    ${security_question_answer_input}     ${SECURITY_QUESTION}
    Wait Until Element Is Visible    ${unmatched_passwords_err}
    Element Should Be Disabled       ${registration_button} 
