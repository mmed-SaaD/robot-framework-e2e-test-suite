*** Variables ***
${login_form_container}    css=.mdc-card
${email_input}    id=email
${password_input}    id=password
${login_button}    id=loginButton
${login_err}    xpath=//*[contains(text(),'Invalid email or password')]
${empty_email_err}    id=mat-mdc-error-0
${empty_password_err}    id=mat-mdc-error-1
${show_password_button}    //*[@id="login-form"]/mat-form-field[2]/div[1]/div/div[3]/button
${navbar_account}    id=navbarAccount
${order_&_payment_button}    css=button[aria-label='Show Orders and Payment Menu']
${order_history_button}    css=button[aria-label='Go to order history page']
${logout_button}    id=navbarLogoutButton
${navbar_login_button}    id=navbarLoginButton
${basket_container}    xpath=//h1[contains(text(), 'Your Basket')]
${close_welcome_banner}    css=button[aria-label='Close Welcome Banner']
