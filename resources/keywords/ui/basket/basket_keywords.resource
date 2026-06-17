*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String
Variables    ../../../../core/utils/env_loader.py
Resource    ../auth/auth_keywords.resource
Resource    ../../../locators/basket/basket.resource
Resource    ../../../locators/products/products.resource
Resource    ../../global_keywords.resource

*** Keywords ***
Pretest Build
    Open Browser To Main Page
    Valid Log In
    Close Cookies Message

Get Products Details By Index
    [Arguments]    ${index}
    ${products_cards}=    Get WebElements    ${product_card}
    ${card}=    Set Variable    ${products_cards}[${index}]

    ${name_element}=    Call Method    ${card}    find_element    xpath    .//div[contains(@class,'item-name')]
    ${price_element}=    Call Method    ${card}    find_element    xpath    .//*[contains(text(),'¤')]
    ${button}=           Call Method    ${card}    find_element    xpath    .//button[contains(.,'Add to Basket')]

    ${name}=    Get Text   ${name_element}
    ${price}=    Get Text   ${price_element}
    
    RETURN    ${name}    ${price}    ${button}

Assert Basket Is Empty
    ${previous_basket_items_count}=    Get Text    ${basket_items_count}
    Should Be Equal As Integers    ${previous_basket_items_count}    0
    Assert Basket Opens
    ${basket_items}=    Get WebElements    ${basket_row_element}
    ${basket_items}=    Get Length    ${basket_items}
    Should Be Equal As Integers    ${basket_items}    0
    

Assert Item Added To Bakset
    Assert Juice List IS Visible
    ${previous_basket_items_count}=    Get Text    ${basket_items_count}
    ${product_name}    ${product_price}    ${add_to_basket_button}=    Get Products Details By Index    0
    Click Button    ${add_to_basket_button}
    Wait Until Element Is Visible    ${item_added_message}
    ${current_basket_items_count}=    Get Text    ${basket_items_count}
    Wait Until Initial Snackbar Disappears
    ${snack_bar_message}=    Get Text    ${item_added_message}
    ${out_of_stock_message_status}=    Run Keyword And Return Status    Should Not Be Equal As Strings    
    ...    ${snack_bar_message}    We are out of stock! Sorry for the inconvenience.
    ${maximum_ordered_message_status}=    Run Keyword And Return Status    Should Not Be Equal As Strings    
    ...    ${snack_bar_message}    You can order only up to 5 items of this product.
        IF     ${out_of_stock_message_status} and ${maximum_ordered_message_status}
            Wait Until Keyword Succeeds    5s    500ms    Wait Until Element Does Not Contain    ${basket_items_count}    ${previous_basket_items_count}   
            ${current_basket_items_count}=    Get Text    ${basket_items_count}
            ${expected_basket_items_count}=    Evaluate    ${previous_basket_items_count} + 1
            Should Be Equal As Integers    ${expected_basket_items_count}    ${current_basket_items_count}
        END
    RETURN    ${product_name}    ${product_price}

Assert Multiple Items Added To Bakset
    Assert Juice List IS Visible
    ${added_items} =    Set Variable    0
    ${products_added_to_basket}=    Create List
    ${current_basket_items_count}=    Get Text    ${basket_items_count}
    FOR    ${index}    IN RANGE    0    2
        ${name}    ${price}    ${button}=    Get Products Details By Index    ${index}
        Click Button    ${button}
        Wait Until Element Is Visible    ${item_added_message}
        ${snack_bar_message}=    Get Text    ${item_added_message}
        ${out_of_stock_message}=    Run Keyword And Return Status    Should Not Be Equal As Strings    
        ...    ${snack_bar_message}    We are out of stock! Sorry for the inconvenience.
        ${maximum_ordered_message_status}=    Run Keyword And Return Status    Should Not Be Equal As Strings    
    ...    ${snack_bar_message}    You can order only up to 5 items of this product.
        IF     ${out_of_stock_message} and ${maximum_ordered_message_status}
            ${added_items}=    Evaluate    ${added_items} + 1
        END
        &{product}=    Create Dictionary    
            ...    name=${name}    price=${price}
            Append To List    ${products_added_to_basket}    ${product}
            Wait Until Element Is Not Visible    ${item_added_message}    10s
    END
    ${updated_basket_items_count}=    Evaluate    ${current_basket_items_count} + ${added_items}
    ${current_basket_items_count}=    Get Text    ${basket_items_count}
    Should Be Equal As Integers    ${current_basket_items_count}    ${updated_basket_items_count}
    RETURN    ${products_added_to_basket}
    
Assert Basket Opens
    Click Button    ${show_basket_button}
    Wait Until Element Is Visible    ${basket_container}

Assert Product Appears In Basket
    ${added_products}=    Assert Multiple Items Added To Bakset
    Assert Basket Opens
    ${basket_items}=    Get WebElements    ${basket_row_element}
    ${count}=    Get Length    ${basket_items}
    FOR    ${index}    IN RANGE    ${count}
        ${basket_item}=    Set Variable    ${basket_items}[${index}]
        ${expected_product}=    Set Variable    ${added_products}[${index}]

        ${actual_name_element}=    Call Method    ${basket_item}    find_element    xpath    ${basket_product_name_element}
        ${actual_price_element}=    Call Method    ${basket_item}    find_element    xpath    ${basket_product_price_element} 

        ${actual_name}=    Get Text    ${actual_name_element}
        ${actual_price}=    Get Text    ${actual_price_element}

        Should Be Equal As Strings    ${expected_product}[name]    ${actual_name}
        Should Be Equal As Strings    ${expected_product}[price]    ${actual_price}
    END

Basket Item Quantity Should Be
    [Arguments]    ${index}    ${expected_quantity}
    ${basket_items}=    Get WebElements    ${basket_row_element}
    ${item}=    Set Variable    ${basket_items}[${index}]
    ${item_quantity_element}=    Call Method    ${item}    find_element    xpath    ${basket_product_quantity_element}
    ${actual_quantity}=    Get Text    ${item_quantity_element}
    Should Be Equal As Integers    ${actual_quantity}    ${expected_quantity}

Assert Basket Item Increase Quantity Works
    Assert Basket Opens
    Wait Until Initial Snackbar Disappears
    ${basket_items}=    Get WebElements    ${basket_row_element}
    ${basket_items_count}=    Get Length    ${basket_items}

    FOR    ${index}    IN RANGE    ${basket_items_count}
        ${basket_items}=    Get WebElements    ${basket_row_element}
        ${item}=    Set Variable    ${basket_items}[${index}]

        ${item_quantity_element}=    Call Method    ${item}    find_element    xpath    ${basket_product_quantity_element}
        ${previous_item_quantity}=    Get Text    ${item_quantity_element}
        ${previous_item_quantity}=    Convert To Integer    ${previous_item_quantity}

        ${set_quantity_buttons}=    Call Method    ${item}    find_elements    xpath    ${basket_product_quantity_buttons}
        ${increase_quantity_button}=    Set Variable    ${set_quantity_buttons}[1]

        Wait Until Keyword Succeeds    5s    500ms
        ...    Click Element    ${increase_quantity_button}

        ${warning_visible}=    Run Keyword And Return Status
        ...    Wait Until Element Is Visible    ${item_cannot_be_added}    2s

        IF    ${warning_visible}
            Basket Item Quantity Should Be    ${index}    ${previous_item_quantity}
            Wait Until Element Is Not Visible    ${item_cannot_be_added}    10s
        ELSE
            ${expected_quantity}=    Evaluate    ${previous_item_quantity} + 1
            Wait Until Keyword Succeeds    5s    500ms
            ...    Basket Item Quantity Should Be    ${index}    ${expected_quantity}
        END
    END

Assert Basket Item Decrease Quantity Works
    Assert Basket Opens
    Wait Until Initial Snackbar Disappears
    ${basket_items}=    Get WebElements    ${basket_row_element}
    ${basket_items_count}=    Get Length    ${basket_items}

    FOR    ${index}    IN RANGE    ${basket_items_count}
        ${item}=    Set Variable    ${basket_items}[${index}]

        ${item_quantity_element}=    Call Method    ${item}    find_element    xpath    ${basket_product_quantity_element}
        ${previous_item_quantity}=    Get Text    ${item_quantity_element}
        ${set_quantity_buttons}=    Call Method    ${item}    find_elements    xpath    ${basket_product_quantity_buttons}
        ${decrease_quantity_button}=    Set Variable    ${set_quantity_buttons}[0]

        IF    ${previous_item_quantity} != 1
            Wait Until Element Is Visible    ${decrease_quantity_button}
            Wait Until Keyword Succeeds    5s    200ms
            ...    Click Button    ${decrease_quantity_button}     
            ${product_out_of_stock}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${item_cannot_be_added}
            IF    not ${product_out_of_stock}
                ${basket_items}=    Get WebElements    ${basket_row_element}
                ${item}=    Set Variable    ${basket_items}[${index}]    
                ${item_quantity_element}=    Call Method    ${item}    find_element    xpath    ${basket_product_quantity_element}
                Wait Until Keyword Succeeds    5s    500ms    Wait Until Element Does Not Contain    ${item_quantity_element}    ${previous_item_quantity}  
                ${actual_item_quantity}=    Get Text    ${item_quantity_element}

                ${expected_quantity}=    Evaluate    ${previous_item_quantity} - 1
                Should Be Equal As Integers    ${expected_quantity}    ${actual_item_quantity}
            END
        END
    END

Basket Items Count Should Be
    [Arguments]    ${expected_count}
    ${basket_items}=    Get WebElements    ${basket_row_element}
    ${count}=    Get Length    ${basket_items}
    Should Be Equal As Integers    ${count}    ${expected_count}

Assert Product Removed From Basket
    Assert Basket Opens
    Wait Until Element Is Visible    ${basket_row_element}
    
    ${basket_items}=    Get WebElements    ${basket_row_element}
    ${previous_basket_items_count}=    Get Length    ${basket_items}
    ${expected_basket_items_count}=    Evaluate    ${previous_basket_items_count} - 1

    ${remove_item_from_basket}=    Call Method    ${basket_items}[0]    find_element    xpath    ${basket_remove_product_button}

    Wait Until Keyword Succeeds    5s    200ms
    ...    Click Element    ${remove_item_from_basket}

    Wait Until Keyword Succeeds    5s    500ms
    ...    Basket Items Count Should Be    ${expected_basket_items_count}

Assert All Products Removed From Basket
    Assert Basket Opens

    WHILE    True
        ${basket_items}=    Get WebElements    ${basket_row_element}
        ${basket_items_count}=    Get Length    ${basket_items}

        IF    ${basket_items_count} == 0
            BREAK
        END

        ${remove_item_button}=    Call Method    ${basket_items}[0]    find_element    xpath    ${basket_remove_product_button}

        Wait Until Keyword Succeeds    5s    200ms
        ...    Click Element    ${remove_item_button}

        ${expected_count}=    Evaluate    ${basket_items_count} - 1

        Wait Until Keyword Succeeds    5s    500ms
        ...    Basket Items Count Should Be    ${expected_count}
    END

Assert Checkout Total Integrity
    Assert Item Added To Bakset
    Assert Basket Opens
    ${items_prices_list}=    Create List
    ${basket_items}=    Get WebElements    ${basket_row_element}
    ${items_in_basket}=    Get Length    ${basket_items}
    Should Not Be Equal As Integers    ${items_in_basket}    0
    ${total_price}=    Set Variable    0
    FOR    ${item}    IN RANGE    ${items_in_basket}
        ${item_price_element}=    Call Method    ${basket_items}[${item}]    find_element    xpath    ${basket_product_price_element}
        ${item_quantity_element}=    Call Method    ${basket_items}[${item}]    find_element    xpath    ${basket_product_quantity_element}
        ${item_price}=    Get Text    ${item_price_element}
        ${item_quantity}=    Get Text    ${item_quantity_element}
        ${item_price}=    Get Regexp Matches    ${item_price}    \\d+\\.\\d+
        ${item_price}=    Evaluate    ${item_price}[0] * ${item_quantity}
        ${total_price}=    Evaluate    ${item_price} + ${total_price}
    END
    ${checkout_total}=    Get Text    ${checkout_total_price}
    ${checkout_total}=    Get Regexp Matches    ${checkout_total}    \\d+\\.\\d+
    Should Be Equal As Numbers    ${checkout_total}[0]    ${total_price}
    RETURN    ${total_price}

Assert Checkout Disabled With Empty Bakset
    Assert Multiple Items Added To Bakset
    Assert Basket Opens
    Assert All Products Removed From Basket
    ${basket_items}=    Get WebElements    ${basket_row_element}
    ${basket_items_count}=    Get Length    ${basket_items}
    Should Be Equal As Integers    ${basket_items_count}    0
    Element Should Be Disabled    ${basket_checkout_button}

Assert Basket Persists After Refresh
    Assert Basket Opens
    Reload Page
    Wait Until Element Is Visible    ${basket_container}
    