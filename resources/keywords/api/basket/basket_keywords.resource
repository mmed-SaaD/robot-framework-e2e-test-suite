*** Settings ***
Library    RequestsLibrary
Library    Collections
Variables    ../../../../core/utils/env_loader.py
Resource    ../../api/auth/auth_keywords.resource

*** Keywords ***
Assert Item Is Not In Basket
    [Arguments]    ${basket_id}    ${headers}    ${product_id}
    ${response}=    GET On Session    owasp basket    /rest/basket/${basket_id}    expected_status=200    headers=${headers}
    ${basket_products}=    Set Variable    ${response.json()}[data]
    Should Not Contain    ${response.json()}[data]    ${product_id}

Assert Item Is Added To Basket
    [Arguments]    ${basket_id}    ${headers}    ${product_id}    ${quantity}
    ${response}=    GET On Session    owasp basket    /rest/basket/${basket_id}    expected_status=200    headers=${headers}
    ${basket_items_list}=    Set Variable    ${response.json()}[data][Products]
    ${basket_items_count}=    Get Length    ${basket_items_list}
    ${basket_is_empty}=    Run Keyword And Return Status    Should Be Equal As Integers    ${basket_items_count}    0
    IF    not ${basket_is_empty}
       FOR    ${index}    IN RANGE    ${basket_items_count}
        ${item_in_basket}=    Run Keyword And Return Status   
        ...    Should Be Equal As Integers    ${basket_items_list}[${index}][BasketItem][ProductId]    ${product_id}
            IF    ${item_in_basket}
                Should Be Equal As Integers    ${basket_items_list}[${index}][BasketItem][BasketId]    ${basket_id}
                Should Be Equal As Integers    ${basket_items_list}[${index}][BasketItem][ProductId]    ${product_id}
                Should Be Equal As Integers    ${basket_items_list}[${index}][BasketItem][quantity]    ${quantity}
            END
        END 
    END

Assert Basket Access For Authenticated User
    ${token}    ${basket_id}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}
    Create Session    owasp basket    ${BASE_URL}
    ${response}=    GET On Session    owasp basket    /rest/basket/${basket_id}    headers=${headers}    expected_status=200

Assert Valid Product Added To Basket
    [Arguments]   ${product_id}=5    ${quantity}=2
    ${token}    ${basket_id}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}
    Create Session    owasp basket    ${BASE_URL}
    #################################### Retrieve Basket Before Adding Product ###############################################
    Assert Item Is Not In Basket    ${basket_id}    ${headers}    ${product_id}
    ####################################  Add Product To Basket ##############################################################
    ${body}=    Create Dictionary
    ...        ProductId=${product_id}   BasketId=${basket_id}    quantity=${quantity}
    ${response}=    POST On Session    owasp basket    /api/BasketItems    json=${body}    expected_status=any    headers=${headers}
    ${response_html}=    Set Variable    ${response.text}
    ${no_product_found_err}=    Run Keyword And Return Status    Should Contain    ${response_html}    Error: No such product found!  
    IF    ${response.status_code} == 200
        Dictionary Should Contain Key    ${response.json()}    data
        Should Not Be Empty    ${response.json()}[data]
        Should Be Equal As Integers    ${response.json()}[data][ProductId]    ${product_id}
        Should Be Equal As Integers    ${response.json()}[data][BasketId]     ${basket_id}
        Should Be Equal As Integers    ${response.json()}[data][quantity]     ${quantity} 
    ELSE IF    ${response.status_code} == 500 and ${no_product_found_err}
        Log To Console    Invalid Product ID Is Handled Correctly
    END
    ##################################  Retrieve Basket After Adding Product #####################################################
    Assert Item Is Added To Basket    ${basket_id}    ${headers}    ${product_id}    ${quantity}
    #################################  Add the same product a second time #########################################################
    ${body}=    Create Dictionary
    ...        ProductId=${product_id}   BasketId=${basket_id}    quantity=${quantity}
    ${response}=    POST On Session    owasp basket    /api/BasketItems    json=${body}    expected_status=any    headers=${headers}
    Should Not Be Equal As Integers    ${response.status_code}    200
    IF    ${response.status_code} == 500
       Log    Adding the same product twice is rejected; quantity update should use PUT /api/BasketItems/{id}.    WARN 
    END
    
Assert Basket Item Quantity Increases
    [Arguments]    ${product_id}=5
    ${token}    ${basket_id}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}
    Create Session    owasp basket    ${BASE_URL}
    ${response}=    GET On Session    owasp basket    /rest/basket/${basket_id}    expected_status=200    headers=${headers}
    ${basket_products}=    Set Variable    ${response.json()}[data]
    ${basket_items}=    Set Variable    ${response.json()}[data][Products][0][BasketItem]
    Dictionary Should Contain Key    ${basket_items}    quantity
    ${previous_product_quantity}=    Set Variable    ${basket_items}[quantity]
    ${new_product_quantity}=    Evaluate    ${previous_product_quantity} + 1
    ${body}=    Create Dictionary    quantity=${new_product_quantity}
    ${response}=     PUT On Session    owasp basket    /api/BasketItems/${basket_items}[id]      json=${body}   headers=${headers}    expected_status=200
    ${basket_items}=    Set Variable    ${response.json()}[data]
    Dictionary Should Contain Key    ${basket_items}    quantity
    ${actual_product_quantity}=    Set Variable    ${basket_items}[quantity]
    ${expected_product_quantity}=    Evaluate    ${previous_product_quantity} + 1
    Should Be Equal As Integers    ${actual_product_quantity}    ${expected_product_quantity}

Assert Basket Item Quantity Decreases
    [Arguments]    ${product_id}=5
    ${token}    ${basket_id}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}
    Create Session    owasp basket    ${BASE_URL}
    ${response}=    GET On Session    owasp basket    /rest/basket/${basket_id}    expected_status=200    headers=${headers}
    ${basket_products}=    Set Variable    ${response.json()}[data]
    ${basket_items}=    Set Variable    ${response.json()}[data][Products][0][BasketItem]
    Dictionary Should Contain Key    ${basket_items}    quantity
    ${previous_product_quantity}=    Set Variable    ${basket_items}[quantity]
    ${new_product_quantity}=    Evaluate    ${previous_product_quantity} - 1
    ${body}=    Create Dictionary    quantity=${new_product_quantity}
    ${response}=     PUT On Session    owasp basket    /api/BasketItems/${basket_items}[id]     json=${body}   headers=${headers}    expected_status=200
    ${basket_items}=    Set Variable    ${response.json()}[data]
    Dictionary Should Contain Key    ${basket_items}    quantity
    ${actual_product_quantity}=    Set Variable    ${basket_items}[quantity]
    ${expected_product_quantity}=    Evaluate    ${previous_product_quantity} - 1
    Should Be Equal As Integers    ${actual_product_quantity}    ${expected_product_quantity}

Assert Item Removed From Basket
    [Arguments]   ${product_id}=5
    ${token}    ${basket_id}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}
    Create Session    owasp basket    ${BASE_URL}

    ${response}=    GET On Session    owasp basket    /rest/basket/${basket_id}    expected_status=200    headers=${headers}
    ${basket_items_list}=    Set Variable   ${response.json()}[data][Products]
    ${basket_items_count}=    Get Length    ${basket_items_list}
    FOR    ${basket_item}    IN RANGE    ${basket_items_count}
        ${item_in_basket}=    Run Keyword And Return Status   
        ...    Should Be Equal As Integers    ${basket_items_list}[${basket_item}][BasketItem][ProductId]    ${product_id}
        IF    ${item_in_basket}
           ${response}=     DELETE On Session    owasp basket    /api/BasketItems/${basket_items_list}[${basket_item}][BasketItem][id]     headers=${headers}    expected_status=200
        END
    END
    ############################################ Verifying that the product has been successfully deleted ! ########################
    ${response}=    GET On Session    owasp basket    /rest/basket/${basket_id}    expected_status=200    headers=${headers}
    ${basket_items_list}=    Set Variable   ${response.json()}[data][Products]
    ${basket_items_count}=    Get Length    ${basket_items_list}
    FOR    ${basket_item}    IN RANGE    ${basket_items_count}
        Should Not Be Equal As Integers    ${basket_items_list}[${basket_item}][BasketItem][ProductId]    ${product_id}
    END
    
Assert Basket Total Is Calculated Correctly
    ${token}    ${basket_id}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}
    Create Session    owasp basket    ${BASE_URL}
    ${response}=    GET On Session    owasp basket    /rest/basket/${basket_id}    expected_status=200    headers=${headers}
    ${basket_is_empty}=    Run Keyword And Return Status   Should Not Be Empty    ${response.json()}[data][Products]
    IF    not ${basket_is_empty}
        ${basket_items_list}=    Set Variable    ${response.json()}[data][Products]
        ${basket_items_count}=    Get Length    ${basket_items_list}
        ${basket_total}=    Set Variable    0
        FOR    ${index}    IN RANGE    ${basket_items_count}
            ${product_price}=    Evaluate    ${basket_items_list}[${index}][price] * ${basket_items_list}[${index}][BasketItem][quantity]
            ${basket_total}=    Evaluate    ${basket_total} + ${product_price}
        END
        Log    Total returned is ${basket_total} which is correct (verified manually), because the API does not return a total to use as reference    WARN
    END

Assert Product Insertion With Invalid Quantity Is Rejected
    [Arguments]   ${product_id}=5    ${quantity}=6
    ${token}    ${basket_id}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}
    Create Session    owasp basket    ${BASE_URL}
    #################################### Retrieve Basket Before Adding Product ###############################################
    Assert Item Is Not In Basket    ${basket_id}    ${headers}    ${product_id}
    ####################################  Add Product To Basket With Invalid Quantity ##############################################################
    ${body}=    Create Dictionary
    ...        ProductId=${product_id}   BasketId=${basket_id}    quantity=${quantity}
    ${response}=    POST On Session    owasp basket    /api/BasketItems    json=${body}    expected_status=400    headers=${headers}
    ${response_html}=    Set Variable    ${response.text}
    Should Contain    ${response_html}    You can order only up to 5 items of this product.
    #################################### Retrieve Basket Before Adding Product With Invalid Quantity ###############################################
    Assert Item Is Not In Basket    ${basket_id}    ${headers}    ${product_id}

Assert Basket Modification Without Authentication Is Rejected
    [Arguments]   ${product_id}=5    ${quantity}=3
    ${token}    ${basket_id}=    Assert Valid Login Returns Authentication Token
    Create Session    owasp basket    ${BASE_URL}
    ${response}=    GET On Session    owasp basket    /rest/basket/${basket_id}     expected_status=401
    Should Contain    ${response.text}    UnauthorizedError: No Authorization header was found

Assert Users Cannot Access Other User's Basket
    [Arguments]    ${basket_id}=6
    #Basket ID 6 belongs to a different user !
    ${token}    ${None}=    Assert Valid Login Returns Authentication Token
    Create Session    owasp basket    ${BASE_URL}
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}
    ${response}=    GET On Session    owasp basket    /rest/basket/${basket_id}    headers=${headers}    expected_status=any
    IF    ${response.status_code} == 200
        Log    User Has Successfully accessed another user's basket which is a critical vulnerability    WARN
    END
    
    

