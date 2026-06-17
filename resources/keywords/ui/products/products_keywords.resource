*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
Resource    ../auth/auth_keywords.resource
Resource    ../../../locators/products/products.resource
Resource    ../../../locators/navigation/navigation.resource
Resource    ../../../variables/products/products_variables.resource
Resource    ../../global_keywords.resource

*** Keywords ***
Pretest Build
    Open Browser To Main Page
    Valid Log In
    Assert Products Are Visible
    Wait Until Initial Snackbar Disappears

Search Product
    [Arguments]    ${search_value}
    ${welcome_banner}=    Run Keyword And Return Status    Page Should Contain    Welcome to OWASP Juice Shop!
    IF    ${welcome_banner}
        Click Button    ${close_welcome_banner}
        Click Element    ${search_icon}
        Wait Until Element Is Visible    ${search_input}
    END
    Press Keys    ${search_input}    CTRL+A    BACKSPACE
    Press Keys    ${search_input}    ${search_value}
    Press Keys    ${search_input}    ENTER

Assert Products Are Visible
    Wait Until Keyword Succeeds    30s    1s    Product Count Should Be    12

Product Count Should Be
    [Arguments]    ${expected}
    ${products_count}=    Get Element Count    ${product_card}
    Should Be Equal As Integers    ${products_count}    ${expected}

Assert Products Names Are Visible
    ${products_names}=    Get WebElements    ${product_name}
    ${products_count}=    Get Length    ${products_names}
    Should Be Equal As Integers    ${products_count}    12
    FOR    ${product}    IN    @{products_names}
        ${name}=    Get Text    ${product}
        ${name}=    Strip String    ${name}

        Should Not Be Empty    ${name}    Missing product name
    END

Assert Products Images Are Visible
    ${products_images}=    Get WebElements    ${product_img}
    ${products_count}=    Get Length    ${products_images}
    Should Be Equal As Integers    ${products_count}    12
    FOR    ${product_image}    IN    @{products_images}
        Element Should Be Visible    ${product_image}
    END

Assert Products Prices Are Visible
    ${products_prices}=    Get WebElements    ${product_price}
    ${products_count}=    Get Length    ${products_prices}
    Should Be Equal As Integers    ${products_count}    12
    FOR    ${product_price}    IN    @{products_prices}
        ${price}=    Get Text    ${product_price}
        Element Should Be Visible    ${product_price}
    END

Assert Products Cards Open Details
    ${products_images}=    Get WebElements    ${product_img}
    Sleep    3s
    Click Image    ${products_images}[4]
    Wait Until Element Is Visible    ${product_card_details}

Assert Products Search By Valid Name Is Functional
    Click Element    ${search_icon}
    Wait Until Element Is Visible    ${search_input}
    Input Text    ${search_input}    text=${searched_product_name}
    Press Keys    ${search_input}    ENTER
    Wait Until Element Is Visible    ${searched_product_card}
    ${retrieved_product_name}=    Get Text    ${product_name}
    Should Be Equal As Strings    ${retrieved_product_name}    ${searched_product_name}

Assert Products Search With No Results
    Click Element    ${search_icon}
    Wait Until Element Is Visible    ${search_input}
    Input Text    ${search_input}    text=${invalid_searched_product_name}
    Press Keys    ${search_input}    ENTER
    Wait Until Element Is Visible    ${no_result_card}
    ${message}=    Get Text    ${no_result_card}
    Should Be Equal As Strings    ${message}    No results found

Clear Search Input
    Click Element    ${search_icon}
    Wait Until Element Is Visible    ${search_input}
    Input Text    ${search_input}    text=${searched_product_name}
    Press Keys    ${search_input}    ENTER
    Wait Until Element Is Visible    ${search_results_header}
    ${searched_value}=    Get Text    ${search_results_header}
    Should Be Equal As Strings    ${searched_value}    ${searched_product_name}
    Press Keys    ${search_input}    CTRL+A    BACKSPACE    ENTER
    Wait Until Element Is Not Visible    ${search_results_header}

Assert Product Pagination Is Functional
    ${displayed_products_count}=    Get Element Count    ${product_card}
    ${selected_items_per_page}=    Get Text    ${item_per_page}
    ${paginator_range_displayed}=    Get Text    ${paginator_range}
    ${page}=    Set Variable   1

    ${matches}=    Get Regexp Matches
    ...        ${paginator_range_displayed}
    ...        \\d+
    Should Be Equal As Integers    ${matches}[0]    ${page}
    Should Be Equal As Integers    ${matches}[1]    ${selected_items_per_page}

    Should Be Equal As Integers    ${displayed_products_count}    ${selected_items_per_page}  
    
    Click Button    ${next_page_button}
    ${range_number_a}=    Evaluate    ${page} + ${selected_items_per_page}
    ${page}=    Set Variable    2
    ${sum}=    Evaluate    ${selected_items_per_page} * ${page}
    ${paginator_range_displayed}=    Get Text    ${paginator_range}

    ${matches}=    Get Regexp Matches
    ...        ${paginator_range_displayed}
    ...        \\d+
    Should Be Equal As Integers    ${matches}[0]    ${range_number_a}
    Should Be Equal As Integers    ${matches}[1]    ${sum}

    Click Button    ${next_page_button}
    ${range_number_a}=    Evaluate    ${range_number_a} + ${selected_items_per_page}
    ${page}=    Set Variable   3
    ${sum}=    Evaluate    ${selected_items_per_page} * ${page}
    ${paginator_range_displayed}=    Get Text    ${paginator_range}

    ${matches}=    Get Regexp Matches
    ...        ${paginator_range_displayed}
    ...        \\d+
    Should Be Equal As Integers    ${matches}[0]    ${range_number_a}
    Should Be Equal As Integers    ${matches}[1]    ${sum}

    Click Button    ${previous_page_button}
    ${range_number_a}=    Evaluate    ${range_number_a} - ${selected_items_per_page}
    ${page}=    Set Variable   2
    ${sum}=    Evaluate    ${selected_items_per_page} * ${page}
    ${paginator_range_displayed}=    Get Text    ${paginator_range}

    ${matches}=    Get Regexp Matches
    ...        ${paginator_range_displayed}
    ...        \\d+
    Should Be Equal As Integers    ${matches}[0]    ${range_number_a}
    Should Be Equal As Integers    ${matches}[1]    ${sum}

    Click Button    ${previous_page_button}
    ${range_number_a}=    Evaluate    ${range_number_a} - ${selected_items_per_page}
    ${page}=    Set Variable   1
    ${sum}=    Evaluate    ${selected_items_per_page} * ${page}
    ${paginator_range_displayed}=    Get Text    ${paginator_range}

    ${matches}=    Get Regexp Matches
    ...        ${paginator_range_displayed}
    ...        \\d+
    Should Be Equal As Integers    ${matches}[0]    ${range_number_a}
    Should Be Equal As Integers    ${matches}[1]    ${sum}

Assert Items Per Page Works
    ${displayed_products_count}=    Get Element Count    ${product_card}
    ${selected_items_per_page}=    Get Text    ${item_per_page}
    Should Be Equal As Integers    ${displayed_products_count}    ${selected_items_per_page}
    Click Element    ${items_per_page_selector}
    ${available_options}=    Get WebElements    ${items_per_page_options}

    Click Element    ${available_options}[0]
    ${displayed_products_count}=    Get Element Count    ${product_card}
    ${selected_items_per_page}=    Get Text    ${item_per_page}
    Should Be Equal As Integers    ${displayed_products_count}    ${selected_items_per_page}

    Click Element    ${items_per_page_selector}
    Click Element    ${available_options}[1]
    ${displayed_products_count}=    Get Element Count    ${product_card}
    ${selected_items_per_page}=    Get Text    ${item_per_page}
    Should Be Equal As Integers    ${displayed_products_count}    ${selected_items_per_page}

    Click Element    ${items_per_page_selector}
    Click Element    ${available_options}[2]
    ${displayed_products_count}=    Get Element Count    ${product_card}
    ${selected_items_per_page}=    Get Text    ${item_per_page}
    Should Be Equal As Integers    ${displayed_products_count}    ${selected_items_per_page}
