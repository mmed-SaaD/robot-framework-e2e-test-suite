*** Settings ***
Resource    ../../resources/keywords/global_keywords.resource
Resource    ../../resources/keywords/ui/basket/basket_keywords.resource
Test Setup  Pretest Build    
Test Teardown  Close Browser Session

*** Test Cases ***
#UI-BASKET-001
Add Product To Basket
    [Tags]    regression    ui    basket    critical
    Assert Item Added To Bakset

#UI-BASKET-002
Add Multiple Products To Basket
    [Tags]    regression    ui    basket
    Assert Multiple Items Added To Bakset

#UI-BASKET-003 Test Case Is Included in both UI-BASKET-001 and UI-BASKET-002 Test Cases

#UI-BASKET-004
Open Basket
    [Tags]    regression    ui    basket
    Assert Basket Opens

#UI-BASKET-005
Product Appears In Basket
    [Tags]    regression    ui    basket
    Assert Product Appears In Basket

#UI-BASKET-006
Increase Product Quantity
    [Tags]    regression    ui    basket
    Assert Basket Item Increase Quantity Works

#UI-BASKET-007
Decrease Product Quantity
    [Tags]    regression    ui    basket
    Assert Basket Item Decrease Quantity Works

#UI-BASKET-008 
Remove Item From Basket
    [Tags]    regression    ui    basket
    Assert Product Removed From Basket

#UI-BASKET-009
Remove All Items From Basket
    [Tags]    regression    ui    basket
    Assert All Products Removed From Basket
    
#UI-BASKET-010 
Checkout Total Integrity
    [Tags]    regression    ui    basket    critical
    Assert Checkout Total Integrity

#UI-BASKET-011
Checkout With Empty Basket
    [Tags]    regression    ui    basket    negative
    Assert Checkout Disabled With Empty Bakset

#UI-BASKET-012
Checkout Status After Refreshing Page
    [Tags]    regression    ui    basket    session
    Assert Basket Persists After Refresh

#UI-BASKET-002
Add Multiple Products To Basket For e2e Test Suite
    [Tags]    regression    ui    basket
    Assert Multiple Items Added To Bakset