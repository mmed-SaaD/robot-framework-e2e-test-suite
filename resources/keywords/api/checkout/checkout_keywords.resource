*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../../api/checkout/checkout_keywords.resource
Resource    ../../api/basket/basket_keywords.resource
Variables    ../../../../core/utils/env_loader.py

*** Keywords ***
Session Setup
    Create Session    owasp orders    ${BASE_URL}
    ${token}    ${basket_id}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary    
    ...    Authorization=Bearer ${token}
    RETURN    ${token}    ${basket_id}    ${headers}

Place And Check Order Confirmation
    [Arguments]    ${headers}    ${basket_id}    ${session_alias}=owasp orders    ${expected_status}=200
    #Get Orders Count
    ${response}=    GET On Session    ${session_alias}    /rest/order-history    headers=${headers}    expected_status=200
    ${list_of_orders}=    Set Variable    ${response.json()}[data]
    ${previous_order_count}=    Get Length    ${list_of_orders}
    #Get Available Addresses
    ${response}=    GET On Session    ${session_alias}    /api/Addresss    headers=${headers}    expected_status=200
    Should Not Be Empty    ${response.json()}[data]
    ${address_selected}=    Set Variable    ${response.json()}[data][0][id]
    #Get Available Payment Cards
    ${response}=    GET On Session    ${session_alias}    /api/Cards    headers=${headers}    expected_status=200
    Should Not Be Empty    ${response.json()}[data]
    ${card_selected}=    Set Variable    ${response.json()}[data][0][id]
    #Get Available Delivery Methods
    ${response}=    GET On Session    ${session_alias}    /api/Deliverys    headers=${headers}    expected_status=200
    Should Not Be Empty    ${response.json()}[data]
    ${delivery_method_selected}=    Set Variable    ${response.json()}[data][2][id]
    #Place Order
    ${order_details}=    Create Dictionary    paymentId=${card_selected}    addressId=${address_selected}    deliveryMethodId=${delivery_method_selected}
    ${body}=    Create Dictionary    couponData=${None}    orderDetails=${order_details}
    ${response}=    POST On Session    ${session_alias}    /rest/basket/${basket_id}/checkout    headers=${headers}    json=${body}    expected_status=${expected_status}
    Dictionary Should Contain Key    ${response.json()}    orderConfirmation
    Should Not Be Empty    ${response.json()}[orderConfirmation]
    ${order_confirmation_id}=    Set Variable    ${response.json()}[orderConfirmation]
    Should Match Regexp    ${order_confirmation_id}    ^[a-z0-9]{4}-[a-z0-9]{16}

    #Get Orders Count
    ${response}=    GET On Session    ${session_alias}    /rest/order-history    headers=${headers}    expected_status=200
    ${list_of_orders}=    Set Variable    ${response.json()}[data]
    ${actual_order_count}=    Get Length    ${list_of_orders}
    ${expected_order_count}=    Evaluate    ${previous_order_count} + 1
    Should Be Equal As Integers    ${actual_order_count}    ${expected_order_count}

    #Make sure the basket is empty after successfully placing an order
    ${response}=    GET On Session     ${session_alias}   /rest/basket/${basket_id}    headers=${headers}    expected_status=200
    Should Be Empty    ${response.json()}[data][Products]    msg=After Order Checkout, the basket should be empty

    #Get Orders Count
    ${response}=    GET On Session    ${session_alias}    /rest/order-history    headers=${headers}    expected_status=200
    ${list_of_orders}=    Set Variable    ${response.json()}[data]
    ${actual_order_count}=    Get Length    ${list_of_orders}

    ${expected_order_count}=    Evaluate    ${previous_order_count} + 1
    Should Be Equal As Integers    ${actual_order_count}    ${expected_order_count}

    RETURN    ${response}    ${order_confirmation_id}    ${list_of_orders}

Assert Authenticated User Can Successfully Place Order With Valid Basket
    ${token}    ${basket_id}    ${headers}    Session Setup
    Assert Valid Product Added To Basket    16    3    owasp orders
    Place And Check Order Confirmation    ${headers}    ${basket_id}

Assert Checkout Fails With Empty Basket
    ${token}    ${basket_id}    ${headers}    Session Setup
    ${response}    ${None}    ${None}=    Place And Check Order Confirmation    ${headers}    ${basket_id}    any
    Should Not Be Equal As Integers    ${response.status_code}    200    msg=An order must not be placed if the basket is empty

Assert Checkout Fails Without Valid Address
    ${token}    ${basket_id}    ${headers}    Session Setup
    #Get Orders Count
    ${response}=    GET On Session    owasp orders    /rest/order-history    headers=${headers}    expected_status=200
    ${list_of_orders}=    Set Variable    ${response.json()}[data]
    ${previous_order_count}=    Get Length    ${list_of_orders}
    #Get Available Payment Cards
    ${response}=    GET On Session    owasp orders    /api/Cards    headers=${headers}    expected_status=200
    Should Not Be Empty    ${response.json()}[data]
    ${card_selected}=    Set Variable    ${response.json()}[data][0][id]
    #Get Available Delivery Methods
    ${response}=    GET On Session    owasp orders    /api/Deliverys    headers=${headers}    expected_status=200
    Should Not Be Empty    ${response.json()}[data]
    ${delivery_method_selected}=    Set Variable    ${response.json()}[data][2][id]
    #Place Order
    ${order_details}=    Create Dictionary    paymentId=${card_selected}    deliveryMethodId=${delivery_method_selected}
    ${body}=    Create Dictionary    couponData=${None}    orderDetails=${order_details}
    ${response}=    POST On Session    owasp orders    /rest/basket/${basket_id}/checkout    headers=${headers}    json=${body}    expected_status=any
    Should Not Be Equal As Integers    ${response.status_code}    200
    ...    msg=Placing an order must fail if an invalid address was selected 
    
Assert Checkout Fails Without Valid Delivery Method
    ${token}    ${basket_id}    ${headers}    Session Setup
    Assert Valid Product Added To Basket    16    3    owasp orders
    #Get Orders Count
    ${response}=    GET On Session    owasp orders    /rest/order-history    headers=${headers}    expected_status=200
    ${list_of_orders}=    Set Variable    ${response.json()}[data]
    ${previous_order_count}=    Get Length    ${list_of_orders}
    #Get Available Addresses
    ${response}=    GET On Session    owasp orders    /api/Addresss    headers=${headers}    expected_status=200
    Should Not Be Empty    ${response.json()}[data]
    ${address_selected}=    Set Variable    ${response.json()}[data][0][id]
    #Get Available Payment Cards
    ${response}=    GET On Session    owasp orders    /api/Cards    headers=${headers}    expected_status=200
    Should Not Be Empty    ${response.json()}[data]
    ${card_selected}=    Set Variable    ${response.json()}[data][0][id]
    #Get Available Delivery Methods
    ${response}=    GET On Session    owasp orders    /api/Deliverys    headers=${headers}    expected_status=200
    Should Not Be Empty    ${response.json()}[data]
    ${delivery_method_selected}=    Set Variable    17
    #Place Order
    ${order_details}=    Create Dictionary    paymentId=${card_selected}    addressId=${address_selected}    deliveryMethodId=${delivery_method_selected}
    ${body}=    Create Dictionary    couponData=${None}    orderDetails=${order_details}
    ${response}=    POST On Session    owasp orders    /rest/basket/${basket_id}/checkout    headers=${headers}    json=${body}    expected_status=any
    Should Not Be Equal As Integers    ${response.status_code}    200    
    ...    msg=Placing an order must fail if an invalid delivery method was selected 

Assert Checkout Fails Without Valid Payment Method 
    ${token}    ${basket_id}    ${headers}    Session Setup
    Assert Valid Product Added To Basket    16    3    owasp orders
    #Get Orders Count
    ${response}=    GET On Session    owasp orders    /rest/order-history    headers=${headers}    expected_status=200
    ${list_of_orders}=    Set Variable    ${response.json()}[data]
    ${previous_order_count}=    Get Length    ${list_of_orders}
    #Get Available Addresses
    ${response}=    GET On Session    owasp orders    /api/Addresss    headers=${headers}    expected_status=200
    Should Not Be Empty    ${response.json()}[data]
    ${address_selected}=    Set Variable    ${response.json()}[data][0][id]
    #Get Available Payment Cards
    ${response}=    GET On Session    owasp orders    /api/Cards    headers=${headers}    expected_status=200
    Should Not Be Empty    ${response.json()}[data]
    ${card_selected}=    Set Variable    ${response.json()}[data][0][id]
    #Get Available Delivery Methods
    ${response}=    GET On Session    owasp orders    /api/Deliverys    headers=${headers}    expected_status=200
    Should Not Be Empty    ${response.json()}[data]
    ${delivery_method_selected}=    Set Variable    ${response.json()}[data][2][id]
    #Place Order
    ${order_details}=    Create Dictionary    addressId=${address_selected}    deliveryMethodId=${delivery_method_selected}
    ${body}=    Create Dictionary    couponData=${None}    orderDetails=${order_details}
    ${response}=    POST On Session    owasp orders    /rest/basket/${basket_id}/checkout    headers=${headers}    json=${body}    expected_status=any
    Should Not Be Equal As Integers    ${response.status_code}    200    
    ...    msg=Placing an order must fail if an invalid payment method was selected 

Assert Order Summary Values Match Basket Values
    ${token}    ${basket_id}    ${headers}    Session Setup
    Assert Valid Product Added To Basket    1    2    owasp orders
    ${response}=    GET On Session    owasp orders    /rest/basket/${basket_id}    headers=${headers}    expected_status=200
    ${basket_products}=    Set Variable    ${response.json()}[data][Products]
    ${total_price}=    Set Variable    0
    ${basket_products_count}=    Get Length    ${basket_products}
    FOR    ${index}    IN RANGE   ${basket_products_count}
        ${item_price}=    Evaluate    ${basket_products}[${index}][BasketItem][quantity] * ${basket_products}[${index}][price]
        ${total_price}=    Evaluate    ${total_price} + ${item_price}
    END
    ${None}    ${order_confirmation_id}    ${list_of_orders}=    Place And Check Order Confirmation    ${headers}    ${basket_id} 
    ${order_total_price}=     Set Variable     ${list_of_orders}[0][totalPrice] 
    Should Be Equal As Numbers    ${order_total_price}    ${total_price}    msg=Order summary total does not match basket total !

Assert User Cannot Place Order For Another User Basket
    [Arguments]   ${product_id}=5    ${quantity}=2    ${session_alias}=owasp orders
    ${token}    ${None}    ${headers}    Session Setup
    #Login As User B
    ${None}    ${basket_id}=    Assert Valid Login Returns Authentication Token    ${VALID_EMAIL7}    
    ${body}=    Create Dictionary
    ...        ProductId=${product_id}   BasketId=${basket_id}    quantity=${quantity}
    ${response}=    POST On Session    ${session_alias}    /api/BasketItems    json=${body}    expected_status=any    headers=${headers}

    ${response}=    GET On Session    owasp orders    /rest/basket/${basket_id}    headers=${headers}    expected_status=200
    ${basket_products}=    Set Variable    ${response.json()}[data][Products]
    ${total_price}=    Set Variable    0
    ${basket_products_count}=    Get Length    ${basket_products}
    FOR    ${index}    IN RANGE   ${basket_products_count}
        ${item_price}=    Evaluate    ${basket_products}[${index}][BasketItem][quantity] * ${basket_products}[${index}][price]
        ${total_price}=    Evaluate    ${total_price} + ${item_price}
    END
    ${response}    ${order_confirmation_id}    ${list_of_orders}=    Place And Check Order Confirmation    ${headers}    ${basket_id} 
    Should Not Be Equal As Integers    ${response.status_code}    200    msg=A user must not be able to place order using other user's baskets

Assert Basket Item Endpoint Ignores Tampered Price
    ${token}    ${basket_id}    ${headers}    Session Setup
    Assert Valid Product Added To Basket    1    2    owasp orders
    ${response}=    GET On Session    owasp orders    /rest/basket/${basket_id}    headers=${headers}    expected_status=200
    ${basket_products}=    Set Variable    ${response.json()}[data][Products]
    ${original_price}=    Set Variable    ${basket_products}[0][price]
    ${body}=    Create Dictionary    price=0.1
    ${response}=    PUT On Session    owasp orders    /api/BasketItems/${basket_products}[0][BasketItem][id]   headers=${headers}    json=${body}    expected_status=200
    ${response}=    GET On Session    owasp orders    /rest/basket/${basket_id}    headers=${headers}    expected_status=200
    ${basket_products}=    Set Variable    ${response.json()}[data][Products]
    ${final_price}=    Set Variable    ${basket_products}[0][price]
    Should Be Equal As Numbers    ${final_price}    ${original_price}
    
    
