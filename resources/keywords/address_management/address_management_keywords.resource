*** Settings ***
Library    SeleniumLibrary
Resource    ../../locators/address_management/address_management.resource
Resource    ../../locators/auth/auth.resource
Resource    ../../locators/checkout/checkout.resource
Resource    ../global_keywords.resource
Resource    ../auth/auth_keywords.resource
Resource    ../checkout/checkout_keywords.resource

*** Keywords ***
Pretest Build
    Open Browser To Main Page
    Valid Log In
    Close Cookies Message

Create New Address
   [Arguments]    ${infos}
    Wait Until Element Is Visible    ${country_input_element}

    FOR    ${key}    ${value}    IN    &{infos}
        IF    '${key}' == 'country'
            Input Text    ${country_input_element}    ${value}
        ELSE IF    '${key}' == 'name'
            Input Text    ${name_input_element}    ${value}
        ELSE IF    '${key}' == 'mobile_number'
            Input Text    ${mobile_number_input_element}    ${value}
        ELSE IF    '${key}' == 'zip'
            Input Text    ${zip_input_element}    ${value}
        ELSE IF    '${key}' == 'address'
            Input Text    ${address_input_element}    ${value}
        ELSE IF    '${key}' == 'city'
            Input Text    ${city_input_element}    ${value}
        ELSE IF    '${key}' == 'state'
            Input Text    ${state_input_element}    ${value}
        END
    END

    Wait Until Element Is Enabled    ${submit_button}
    Click Button    ${submit_button}

Update Existing Address
   [Arguments]    ${infos}
    Wait Until Element Is Visible    ${country_input_element}
    FOR    ${key}    ${value}    IN    &{infos}
        IF    '${key}' == 'country'
            ${previous_country}=    Get Element Attribute    ${country_input_element}    value
            IF    '${value}' != '${previous_country}'
                Input Text    ${country_input_element}    ${value}
            END
        ELSE IF    '${key}' == 'name'
            ${previous_name}=    Get Element Attribute    ${name_input_element}    value
            IF    '${value}' != '${previous_name}'
                Input Text    ${name_input_element}    ${value}
            END
        ELSE IF    '${key}' == 'mobile_number'
            ${previous_mobile_number}=    Get Element Attribute    ${mobile_number_input_element}    value
            IF    '${value}' != '${previous_mobile_number}'
                Input Text    ${mobile_number_input_element}    ${value}
            END
        ELSE IF    '${key}' == 'zip'
            ${previous_zip}=    Get Element Attribute    ${zip_input_element}    value
            IF    '${value}' != '${previous_zip}'
                Input Text    ${zip_input_element}    ${value}
            END
        ELSE IF    '${key}' == 'address'
            ${previous_address}=    Get Element Attribute    ${address_input_element}    value
            IF    '${value}' != '${previous_address}'
                Input Text    ${address_input_element}    ${value}
            END
        ELSE IF    '${key}' == 'city'
            ${previous_city}=    Get Element Attribute    ${city_input_element}    value
            IF    '${value}' != '${previous_city}'
                Input Text    ${city_input_element}    ${value}
            END
        ELSE IF    '${key}' == 'state'
            ${previous_state}=    Get Element Attribute    ${state_input_element}    value
            IF    '${value}' != '${previous_state}'
                Input Text    ${state_input_element}    ${value}
            END
        END
    END

    Wait Until Element Is Enabled    ${submit_button}
    Click Button    ${submit_button}

Assert Saved Addresses Page Opens
    Click Button    ${navbar_account}
    Wait Until Element Is Visible    ${order_&_payment_button}
    Mouse Over    ${order_&_payment_button}
    Wait Until Element Is Visible    ${saved_addresses_button}
    Click Button    ${saved_addresses_button}
    Page Should Contain    My saved addresses

Assert Valid Address Added
    ${address_infos_list}=    Create Dictionary
    ...    country=${COUNTRY2}    name=${NAME2}    mobile_number=${MOBILE_NUMBER2}    
    ...    zip=${ZIP2}    address=${ADDRESS2}    city=${CITY2}    state=${STATE2}
    Assert Saved Addresses Page Opens
    Click Button    ${add_new_address_button}
    Create New Address    ${address_infos_list}
    Wait Until Element Is Visible    ${saved_addresses_table}
    Page Should Contain    My saved addresses
    Page Should Contain    ${address_infos_list}[country]
    Page Should Contain    ${address_infos_list}[name]
    Page Should Contain    ${address_infos_list}[zip]

Assert Invalid Address Handled - Missing Required Fields
        ${address_infos_list}=    Create Dictionary
    ...    country=${COUNTRY2}    mobile_number=${MOBILE_NUMBER2}    
    ...    address=${ADDRESS2}    city=${CITY2}    state=${STATE2}
    Assert Saved Addresses Page Opens
    Click Button    ${add_new_address_button}
    ${address_added_status}=    Run Keyword And Return Status     Create New Address    ${address_infos_list}
    IF    not ${address_added_status}
        Element Should Be Disabled    ${submit_button}
        RETURN
    END    
    Wait Until Element Is Visible    ${saved_addresses_table}
    Page Should Contain    My saved addresses

Assert Address Updated Successfully
    Assert Saved Addresses Page Opens
    ${address_infos_list}=    Create Dictionary
    ...    country=${COUNTRY2}    name=${NAME}    mobile_number=${MOBILE_NUMBER2}    
    ...    zip=${ZIP}    address=${ADDRESS2}    city=${CITY}    state=${STATE2}
    ${available_addresses}=    Get WebElements    ${saved_address_row}
    ${available_addresses_count}=    Get Length    ${available_addresses}
    IF    ${available_addresses_count} != 0
        ${address_update_button}=    Call Method    ${available_addresses}[0]    find_element    xpath    .//mat-cell[4]//button
        Click Button    ${address_update_button}
        Update Existing Address    ${address_infos_list}
    END
    RETURN

Assert Address Deletion
    Assert Saved Addresses Page Opens
    ${available_addresses}=    Get WebElements    ${saved_address_row}
    ${available_addresses_count}=    Get Length    ${available_addresses}
    IF    ${available_addresses_count} != 0
        ${address_deletion_button}=    Call Method    ${available_addresses}[0]    find_element    xpath    .//mat-cell[5]//button
        Click Button    ${address_deletion_button}
        Wait Until Element Is Visible    ${address_removed_message_container}
        Page Should Contain    Your address has been removed.
        ${current_available_addresses}=    Get WebElements    ${saved_address_row}
        ${current_available_addresses_count}=    Get Length    ${current_available_addresses}
        ${expected_available_addresses_count}=    Evaluate    ${available_addresses_count} - 1
        Should Be Equal As Integers    ${expected_available_addresses_count}    ${current_available_addresses_count}
    END
    RETURN
    
Assert Added Addresses Appear During Checkout
    ${checkout_process_status}=    checkout_keywords.Assert Checkout Process Starts
    IF    not ${checkout_process_status}
        RETURN
    END
    Page Should Contain    ${COUNTRY2}
    Page Should Contain    ${NAME2}
    Page Should Contain    ${ZIP2}