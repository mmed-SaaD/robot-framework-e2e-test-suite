*** Settings ***
Resource    ../../resources/keywords/api/checkout/checkout_keywords.resource

*** Test Cases ***
#API-CHECKOUT-001    API-CHECKOUT-007
Authenticated User Can Place Order With Valid Basket, Address, Delivery, And Payment Data
    [Tags]    regression    api    checkout    critical    contract
    Assert Authenticated User Can Successfully Place Order With Valid Basket

#API-CHECKOUT-002
Checkout Fails With Empty Basket
    [Tags]    regression    api    checkout    negative
    Assert Checkout Fails With Empty Basket

#API-CHECKOUT-003
Checkout Fails Without Valid Address
    [Tags]    regression    api    checkout    negative
    Assert Checkout Fails Without Valid Address

#API-CHECKOUT-004
Checkout Fails Without Valid Delivery Method
    [Tags]    regression    api    checkout    negative
    Assert Checkout Fails Without Valid Delivery Method

#API-CHECKOUT-005
Checkout Fails Without Valid Payment Method
    [Tags]    regression    api    checkout    negative
    Assert Checkout Fails Without Valid Payment Method 

#API-CHECKOUT-006
Order Summary Values Match Basket Values
    [Tags]    regression    api    checkout    contract
    Assert Order Summary Values Match Basket Values

#API-CHECKOUT-009
User Cannot Place Order For Another User Basket
    [Tags]    regression    api    checkout    broken-access-control
    Assert User Cannot Place Order For Another User Basket

#API-CHECKOUT-010
Basket Item Endpoint Ignores Tampered Price Field
    [Tags]    regression    api    checkout    security
    Assert Basket Item Endpoint Ignores Tampered Price
