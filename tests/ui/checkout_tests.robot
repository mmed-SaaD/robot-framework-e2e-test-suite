*** Settings ***
Resource    ../../resources/keywords/global_keywords.resource
Resource    ../../resources/keywords/ui/checkout/checkout_keywords.resource
Resource    ../../resources/keywords/ui/basket/basket_keywords.resource
Test Setup  Checkout_keywords.Pretest Build
Test Teardown  Close Browser Session

*** Test Cases ***
#UI-CHECKOUT-001 UI-CHECKOUT-002
Logged In User Checkout Process
    [Tags]    regression    ui    checkout    critical
    basket_keywords.Assert Item Added To Bakset
    Assert Checkout Process Starts

#UI-CHECKOUT-003
Add New Address To Checkout
    [Tags]    regression    ui    checkout    address
    Assert Address Added During Checkout

#UI-CHECKOUT-004
Choose Existing Address During Checkout
    [Tags]    regression    ui    checkout    address
    Assert Existing Address Use During Checkout

#UI-CHECKOUT-005
Choose Delivery Method
    [Tags]    regression    ui    checkout
    Assert Delivery Method Selected

#UI-CHECKOUT-006
Choose Payment Method 
    [Tags]    regression    ui    checkout    payment
    Assert Payment Method Selected

#UI-CHECKOUT-007
Review And Screenshot Order Summary 
    [Tags]    regression    ui    checkout
    Assert Order Summary Integrity

#UI-CHECKOUT-008
Place Order Successfully
    [Tags]    regression    ui    checkout    critical
    checkout_keywords.Assert Order Placed Successfully

#UI-CHECKOUT-009
Order Confirmation Is Displayed
    [Tags]    regression    ui    checkout
    Assert Order Confirmation Is Displayed

#UI-CHECKOUT-010
Basket Is Cleared After Order
    [Tags]    regression    ui    checkout    basket
    Assert Basket Is Cleared After Order

#UI-CHECKOUT-011
Order Appears In Order History
    [Tags]    regression    ui    checkout    account
    Assert Order Appears In Order History
