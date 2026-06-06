*** Settings ***
Resource    ../../resources/keywords/api/e2e/e2e_keywords.resource

*** Test Cases ***
#API-E2E-001
Register User, Login, Add Product To Bsket, Checkout Successfully
    [Tags]    e2e    api    critical
    Assert Registration, Login, Adding Product And Checkout

#API-E2E-002
Login Existing User, Add Product, Update Quantity, Remove Product
    [Tags]    e2e    api    basket
    Assert Login, Add Product, Update Quantity And Remove Product

#API-E2E-003
Login Existing User, Create Address, Create Payment Method, Place Order
    [Tags]    e2e    api    checkout
    Assert Login, Address Creation, Payment Method Creation And Placing Order

#API-E2E-004
Attempt Checkout With Missing Required Data And Verify Rejection
    [Tags]    e2e    api    negative    checkout
    Assert Checkout Attempt With Missing Required Dara Is Rejected

#API-E2E-005
User A Cannot Access User B Basket, Address, Payment, Or Order Data
    [Tags]    e2e    api    security    broken-access-control
    Assert User Sensitive Data Protection