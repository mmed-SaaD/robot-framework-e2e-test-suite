*** Settings ***
Library    SeleniumLibrary
Library    String
Resource    ../../../locators/auth/auth.resource
Resource    ../../../locators/payment/payment.resource
Resource    ../../../locators/checkout/checkout.resource
Resource    ../../global_keywords.resource
Resource    ../auth/auth_keywords.resource
Resource    ../checkout/checkout_keywords.resource

*** Keywords ***
Pretest Build
    Open Browser To Main Page
    Valid Log In
    Close Cookies Message

Add New Credit Card
    [Arguments]    ${credit_card_info}
    Element Should Be Disabled    ${submit_button}
    Click Element    ${add_credit_card_container}
    ${credit_card_details_inputs}=    Get WebElements    xpath=${credit_card_info_container}
    ${credit_card_details_selects}=    Get WebElements    ${credit_card_info_select}
    ${selects_index}=    Set Variable    0
    FOR    ${key}    ${value}    IN    &{credit_card_info}
        IF    '${key}' == 'name'
            Input Text    ${credit_card_details_inputs}[0]    ${credit_card_info}[name]
        ELSE IF    '${key}' == 'card_number'
            Input Text    ${credit_card_details_inputs}[1]    ${credit_card_info}[card_number]
        ELSE IF    '${key}' == 'expiry_month'
            Select From List By Value    ${credit_card_details_selects}[0]     ${credit_card_info}[expiry_month]
        ELSE IF    '${key}' == 'expiry_year'
            Select From List By Value    ${credit_card_details_selects}[1]     ${credit_card_info}[expiry_year]
        END        
    END

    ${provided_info_count}=    Get Length    ${credit_card_info}
    ${invalid_credit_card_inputs}=    Run Keyword And Return Status    Element Should Be Visible    xpath=//mat-error
    IF    not ${invalid_credit_card_inputs} and ${provided_info_count} == 4
        Wait Until Element Is Enabled    ${submit_button}    
        Click Button    ${submit_button}
    END

Assert Saved Payment Options Page Opens Successfully
    Click Button    ${navbar_account}
    Wait Until Element Is Visible    ${order_&_payment_button}
    Mouse Over    ${order_&_payment_button}
    Wait Until Element Is Visible    ${payment_options_button}
    Click Button    ${payment_options_button}
    Page Should Contain    My Payment Options

Assert New Payment Method Added
    Assert Saved Payment Options Page Opens Successfully
    &{credit_card_details}=    Create Dictionary
    ...        name=${NAME2}       card_number=${CARD_NUMBER2}    expiry_month=${EXPIRY_MONTH2}    expiry_year=${EXPIRY_YEAR2}
    Add New Credit Card    ${credit_card_details}  
    Wait Until Element Is Visible    ${item_added_message}
    ${snack_bar_message}=    Get Text    ${item_added_message}
    Page Should Contain    My Payment Options
    Page Should Contain    ${NAME2}
    Page Should Contain    ${EXPIRY_MONTH2}/${EXPIRY_YEAR2}
    ${credit_card_number_4_digits}=    Get Regexp Matches    ${CARD_NUMBER2}    \\d{4}$
    Page Should Contain    ${credit_card_number_4_digits}[0]
    Should Be Equal As Strings    ${snack_bar_message}   Your card ending with ${credit_card_number_4_digits}[0] has been saved for your convenience.  

Assert New Card With Missing Fields
    Assert Saved Payment Options Page Opens Successfully
    &{credit_card_details}=    Create Dictionary
    ...        name=${NAME2}           expiry_year=${EXPIRY_YEAR2}
    Add New Credit Card    ${credit_card_details}  
    Element Should Be Disabled    ${submit_button}

Assert New Card With Invalid Card Number
    Assert Saved Payment Options Page Opens Successfully
    &{credit_card_details}=    Create Dictionary
    ...        name=${NAME2}       card_number=${INVALID_CARD_NUMBER}    expiry_month=${EXPIRY_MONTH2}    expiry_year=${EXPIRY_YEAR2}
    Add New Credit Card    ${credit_card_details}  
    Page Should Contain     Please enter a valid sixteen digit card number.
    Element Should Be Disabled    ${submit_button}

Assert New Payment Method Selected During Checkout
    basket_keywords.Assert Item Added To Bakset
    Assert Delivery Method Selected
    ${card_number_4_digits}=    Get Regexp Matches    ${CARD_NUMBER2}    \\d{4}$
    Page Should Contain    ${card_number_4_digits}[0]
    Page Should Contain    ${NAME2}
    Page Should Contain    ${EXPIRY_MONTH2}/${EXPIRY_YEAR2}


Assert Payment Method Deletion
    Assert Saved Payment Options Page Opens Successfully
    ${available_payment_methods}=    Get WebElements    ${saved_payment_methods_row}
    ${available_payment_methods_count}=    Get Length    ${available_payment_methods}
    IF    ${available_payment_methods_count} != 0
        ${payment_method_deletion_button}=    Call Method    ${available_payment_methods}[0]    find_element    xpath    .//mat-cell[4]//button
        Click Button    ${payment_method_deletion_button}
        ${current_available_payment_methods}=    Get WebElements    ${saved_payment_methods_row}
        ${current_available_payment_methods_count}=    Get Length    ${current_available_payment_methods}
        ${expected_available_payment_methods_count}=    Evaluate    ${available_payment_methods_count} - 1
        Should Be Equal As Integers    ${expected_available_payment_methods_count}    ${current_available_payment_methods_count}
    END
    RETURN