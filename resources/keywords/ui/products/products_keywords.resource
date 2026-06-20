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
    Log To Console    Opening browser...
    Open Browser To Main Page

    Log To Console    Logging in...
    Valid Log In

    Log To Console    Debugging CI layout...
    Debug Products Layout

    Log To Console    Waiting for products...
    Assert Products Are Visible

    Log To Console    Waiting snackbar...
    Wait Until Initial Snackbar Disappears

    Log To Console    Pretest finished.

Debug Products Layout
    Capture Page Screenshot    before_products_check.png

    ${url}=    Get Location
    ${width}=    Execute Javascript    return window.innerWidth;
    ${height}=   Execute Javascript    return window.innerHeight;

    ${tiles}=    Get Element Count    xpath=//mat-grid-tile
    ${cards}=    Get Element Count    xpath=//mat-card
    ${buttons}=  Get Element Count    xpath=//button[contains(.,'Add to Basket')]

    Log To Console    CURRENT URL: ${url}
    Log To Console    WIDTH=${width}
    Log To Console    HEIGHT=${height}
    Log To Console    GRID TILES=${tiles}
    Log To Console    MAT CARDS=${cards}
    Log To Console    ADD BUTTONS=${buttons}

    ${has_item_per_page}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${item_per_page}

    IF    ${has_item_per_page}
        ${items}=    Get Text    ${item_per_page}
        Log To Console    ITEMS PER PAGE=${items}
    END

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
    Capture Page Screenshot
    Wait Until Keyword Succeeds    90s    1s    Product Count Should Be    12

Product Count Should Be
    [Arguments]    ${expected}
    Wait Until Keyword Succeeds    90s    500ms    Element Should Be Visible    ${product_card}
    ${products_count}=    Get Element Count    ${product_card}
    Should Be True    ${products_count} >= ${expected}

Assert Products Names Are Visible
    ${product_cards}=    Get WebElements    ${product_name}
    ${products_count}=    Get Length    ${product_cards}
    Should Be True    ${products_count} >= 12
    FOR    ${card}    IN    @{product_cards}
        ${name_element}=    Call Method    ${card}    find_element    xpath    .//*[contains(@class,'item-name')]
        ${name}=    Get Text    ${name_element}
        ${name}=    Strip String    ${name}
        Should Not Be Empty    ${name}    Missing product name
    END

Assert Products Images Are Visible
    ${products_images}=    Get WebElements    ${product_img}
    ${products_count}=    Get Length    ${products_images}
    Should Be True    ${products_count} >= 12
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
    Capture Page Screenshot    search_attempt.png
    Wait Until Keyword Succeeds    30s    1s    Click Element   ${search_icon}
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
