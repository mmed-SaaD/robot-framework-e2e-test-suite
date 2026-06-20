*** Settings ***
Library    SeleniumLibrary
Library    String
Variables    ../../../../core/utils/env_loader.py
Resource    ../../../locators/basket/basket.resource
Resource    ../../../locators/checkout/checkout.resource
Resource    ../basket/basket_keywords.resource
Resource    ../../global_keywords.resource
Resource    ../../../locators/auth/auth.resource
Resource    ../auth/auth_keywords.resource


*** Keywords ***
Pretest Build
    Open Browser To Main Page
    Valid Log In
    Close Cookies Message

Assert Checkout Process Starts
    Click Button    ${show_basket_button}
    Capture Page Screenshot    basket_row.png
    Wait Until Element Is Visible    ${basket_row_element}
    ${basket_items}=    Get WebElements    ${basket_row_element}
    ${basket_items_count}=    Get Length    ${basket_items}
    ${proceed_to_checkout_button_status}=    Run Keyword And Return Status    Element Should Be Disabled    ${basket_checkout_button}
    Wait Until Initial Snackbar Disappears
    IF    ${basket_items_count} > 0 and not ${proceed_to_checkout_button_status}
        Click Button    ${basket_checkout_button}
        Wait Until Element Is Visible    ${add_new_address_button} 
        RETURN    ${True}
    ELSE IF    ${proceed_to_checkout_button_status}
        RETURN     ${False}
    END

Assert Address Added During Checkout
    ${checkout_process_started}=     Assert Checkout Process Starts
    IF    ${checkout_process_started}
        Click Button    ${add_new_address_button}
        Wait Until Element Is Visible    ${country_input_element}
        Input Text    ${country_input_element}    ${COUNTRY2}
        Input Text    ${name_input_element}    ${NAME2}
        Input Text    ${mobile_number_input_element}    ${MOBILE_NUMBER2}
        Input Text    ${zip_input_element}    ${ZIP2}
        Input Text    ${address_input_element}    ${ADDRESS2}
        Input Text    ${city_input_element}    ${CITY2}
        Input Text    ${state_input_element}    ${STATE2}
        Wait Until Element Is Enabled    ${submit_button}
        Click Button    ${submit_button}
        Wait Until Element Is Visible    ${add_new_address_button}
        Page Should Contain    ${COUNTRY2}
        Page Should Contain    ${ADDRESS2} 
    END

Assert Existing Address Use During Checkout
    ${checkout_process_started}=     Assert Checkout Process Starts
    IF    ${checkout_process_started}
        Wait Until Element Is Visible    ${addresses_list_row_element}
        ${list_of_address}=    Get WebElements    ${addresses_list_row_element}
        ${address_selection_button}=    Call Method    ${list_of_address}[0]    find_element    xpath    .//mat-radio-button
        Click Element    ${address_selection_button}
        Element Attribute Value Should Be    ${address_selection_button}    class    mat-mdc-radio-button mat-accent cdk-focused cdk-mouse-focused mat-mdc-radio-checked
    END

Assert Delivery Method Selected
    Assert Existing Address Use During Checkout
    Wait Until Keyword Succeeds    5s    500ms    Element Should Be Visible    ${continue_to_delivery_button}  
    Click Button    ${continue_to_delivery_button}
    Wait Until Element Is Visible    ${methods_table}
    ${delivery_methods}=    Get WebElements    ${delivery_method_row}
    ${selected_delivery_method}=    Call Method    ${delivery_methods}[1]    find_element    xpath    ${delivery_method_cell}
    ${selected_delivery_method_cost}=    Call Method    ${delivery_methods}[1]    find_element    xpath    ${delivery_method_cost_cell}
    ${selected_delivery_method_cost}=    Get Text    ${selected_delivery_method_cost}
    ${selected_delivery_method_cost}=    Get Regexp Matches    ${selected_delivery_method_cost}    \\d+\\.\\d+
    Click Element    ${selected_delivery_method}
    Click Button    ${continue_to_payment_button}
    RETURN    ${selected_delivery_method_cost}[0]

Assert Payment Method Selected
    ${delivery_cost}=    Assert Delivery Method Selected
    Wait Until Element Is Visible    ${payment_methods_page_header}
    ${payment_methods_exist}=    Run Keyword And Return Status        Wait Until Element Is Visible   ${methods_table}
    IF    not ${payment_methods_exist}
            ${credit_card_details}=    Create List    ${NAME2}       ${CARD_NUMBER2}    ${EXPIRY_MONTH2}    ${EXPIRY_YEAR2}
            Element Should Be Disabled    ${submit_button}
            Click Element    ${add_credit_card_container}
            ${credit_card_details_inputs}=    Get WebElements    xpath=${credit_card_info_container}
            ${credit_card_details_selects}=    Get WebElements    ${credit_card_info_select}
            ${selects_index}=    Set Variable    0
            FOR    ${index}    IN RANGE    4
                IF    ${index} < 2
                    Input Text    ${credit_card_details_inputs}[${index}]    ${credit_card_details}[${index}]
                ELSE
                    Select From List By Value    ${credit_card_details_selects}[${selects_index}]     ${credit_card_details}[${index}]
                    ${selects_index}=    Evaluate    ${selects_index} + 1
                END
            END
            Wait Until Element Is Enabled    ${submit_button}    
            Click Button    ${submit_button}
    END
    Wait Until Element Is Visible    ${methods_table}
    ${payment_methods_container}=    Get WebElement    ${methods_table}
    ${payment_method_selection}=    Call Method    ${payment_methods_container}    find_elements    xpath    .//mat-row//mat-cell[1]//mat-radio-button
    ${payment_options_count}=    Get Length    ${payment_method_selection}
    Click Element    ${payment_method_selection}[0]
    Element Should Be Enabled    ${proceed_to_review_button}
    Click Button    ${proceed_to_review_button}
    RETURN    ${delivery_cost}

Assert Order Summary Integrity
    ${card_number_4_digits}=    Get Regexp Matches    ${CARD_NUMBER2}    \\d{4}
    ${basket_total}=    basket_keywords.Assert Checkout Total Integrity
    ${delivery_cost}=     Assert Payment Method Selected
    Location Should Contain    order-summary
    Wait Until Page Contains    ${NAME2}
    Wait Until Page Contains    ${ADDRESS2}
    Wait Until Page Contains    ${card_number_4_digits}[0]
    Wait Until Page Contains    ${delivery_cost}
    ${order_total}=    Evaluate    ${basket_total} + ${delivery_cost}
    Wait Until Page Contains    ${order_total}
    RETURN    ${order_total}
    
Assert Order Placed Successfully
    ${order_total}=    Assert Order Summary Integrity
    Wait Until Element Is Visible    ${checkout_button}
    Click Button    ${checkout_button}
    Wait Until Page Contains   Thank you for your purchase!
    Wait Until Page Contains    ${ADDRESS2}
    Wait Until Page Contains    ${order_total}

Assert Order Confirmation Is Displayed
    Assert Order Placed Successfully
    Wait Until Element Is Visible    ${print_order}
    Click Button    ${print_order}
    ${handles}=    Get Window Handles
    Switch Window    ${handles}[1]
    Location Should Contain    .pdf
    ${full_url}=    Get Location
    ${order_id}=    Get Regexp Matches    ${full_url}    order_([^.]+)\\.pdf    1
    Switch Window    ${handles}[0]
    Click Button    ${to_homepage_button}
    RETURN    ${order_id}[0]

Assert Basket Is Cleared After Order
    Assert Order Placed Successfully
    basket_keywords.Assert Basket Is Empty

Assert Order Appears In Order History
    ${order_id}=    Assert Order Confirmation Is Displayed
    Click Button    ${navbar_account}
    Wait Until Element Is Visible    ${order_&_payment_button}
    Mouse Over    ${order_&_payment_button}
    Wait Until Element Is Visible    ${order_history_button}
    Click Button    ${order_history_button}
    Wait Until Element Is Visible    ${order_history_header}
    Page Should Contain    \#${order_id}
    

