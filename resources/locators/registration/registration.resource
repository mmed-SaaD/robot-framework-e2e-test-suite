*** Variables ***
${registration_form}    id=registration-form
${security_question_option}    xpath=//mat-option[.//span[contains(.,'eldest siblings middle name')]]
${email_input}    id=emailControl
${password_input}    id=passwordControl
${repeated_password_input}    id=repeatPasswordControl
${registration_security_question_list}    css=.mat-mdc-select-arrow
${security_question_answer_input}    id=securityAnswerControl
${registration_button}    id=registerButton    
${empty_email_err}    xpath=//mat-error[contains(text(), 'Please provide an email address.')]
${empty_password_err}    xpath=//mat-error[contains(text(), 'Please provide a password.')]
${empty_repeated_password_err}    xpath=//mat-error[contains(text(), ' Please repeat your password.')]
${unique_email_info}    xpath=//div[contains(text(), 'Email must be unique')]
${invalid_email_err}    xpath=//mat-error[contains(text(), 'Email address is not valid.')]
${weak_password_err}    xpath=//mat-error[contains(text(), 'Password must be 5-40 characters long.')]
${unmatched_passwords_err}    xpath=//mat-error[contains(text(), 'Passwords do not match')]



