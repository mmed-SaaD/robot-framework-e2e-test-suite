*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../../api/auth/auth_keywords.resource
Resource    ../../api/registration/registration_keywords.resource
Resource    ../../api/checkout/checkout_keywords.resource
Resource    ../../api/basket/basket_keywords.resource
Resource    ../../api/address/address_keywords.resource
Resource    ../../api/payment/payment_keywords.resource
Resource    ../../api/checkout/checkout_keywords.resource
Variables    ../../../../core/utils/env_loader.py

*** Keywords ***
Session Setup
    Create Session    owasp e2e    ${BASE_URL}
    ${token}    ${basket_id}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary        
    ...    Authorization=Bearer ${token}
    RETURN    ${token}    ${headers}    ${basket_id}

Assert Registration, Login, Adding Product And Checkout
    Assert User Registration With Valid Data    ${VALID_EMAIL6}
    ${token}    ${headers}    ${basket_id}=    Session Setup    
    ${body}=    Create Dictionary
    ...        ProductId=6   BasketId=${basket_id}    quantity=1
    ${response}=    POST On Session    owasp e2e    /api/BasketItems    json=${body}    expected_status=any    headers=${headers}
    ${response_html}=    Set Variable    ${response.text}

        Dictionary Should Contain Key    ${response.json()}    data
        Should Not Be Empty    ${response.json()}[data]
        Should Be Equal As Integers    ${response.json()}[data][ProductId]    6
        Should Be Equal As Integers    ${response.json()}[data][BasketId]     ${basket_id}
        Should Be Equal As Integers    ${response.json()}[data][quantity]     1 

    Place And Check Order Confirmation    ${headers}    ${basket_id}    owasp e2e

Assert Login, Add Product, Update Quantity And Remove Product
    ${token}    ${headers}    ${basket_id}=    Session Setup    
    Assert Valid Product Added To Basket
    Assert Basket Item Quantity Increases
    Assert Item Removed From Basket

Assert Login, Address Creation, Payment Method Creation And Placing Order
    ${token}    ${headers}    ${basket_id}=    Session Setup    
    Assert Address Creation With Valid Data
    Assert Valid Payment Method Added
    Place And Check Order Confirmation    ${headers}    ${basket_id}    session_alias=owasp e2e

Assert Checkout Attempt With Missing Required Dara Is Rejected
    ${token}    ${headers}    ${basket_id}=    Session Setup    
    Assert Valid Product Added To Basket
    Assert Checkout Fails Without Valid Address

Assert User Sensitive Data Protection
    ${token}    ${headers}    ${basket_id}=    Session Setup    
    Assert Valid Product Added To Basket
    Assert User Cannot Place Order For Another User Basket


