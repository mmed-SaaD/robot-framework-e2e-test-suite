*** Settings ***
Resource     ../../locators/auth/auth.resource

*** Variables ***
${login_err_message}    Get Text    ${login_err}
${invalid_email}    not_customer@gmail.com
${invalid_password}    invalid_password
${badly_formatted_email}    not_customer.gmail.com
${empty_email_err_message}    Please provide an email address.
${empty_password_err_message}    Please provide a password.