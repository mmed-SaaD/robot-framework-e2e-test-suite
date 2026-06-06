*** Settings ***
Resource    ../../resources/keywords/api/basket/basket_keywords.resource

*** Test Cases ***
#API-BASKET-001
Access Basket For Authenticated User
    [Tags]    regression    api    basket    critical
    Assert Basket Access For Authenticated User

#API-BASKET-002    API-BASKET-003    API-BASKET-004    API-BASKET-009
Add Valid Product To Basket
    [Tags]    regression    api    basket    critical
    Assert Valid Product Added To Basket 

#API-BASKET-005
Increase Basket Item Quantity
    [Tags]    regression    api    basket
    Assert Basket Item Quantity Increases

#API-BASKET-006
Decrease Basket Item Quantity
    [Tags]    regression    api    basket
    Assert Basket Item Quantity Decreases

#API-BASKET-007
Remove Basket Item
    [Tags]    regression    api    basket
    Assert Item Removed From Basket

#API-BASKET-008
Basket Total Is Calculated Correctly   
    [Tags]    regression    api    basket    critical
    Assert Basket Total Is Calculated Correctly

#API-BASKET-010
Add Product With Invalid Quantity Is Rejected
    [Tags]    regression    api    basket    negative
    Assert Product Insertion With Invalid Quantity Is Rejected

#API-BASKET-011
Modify Basket Without Authentication
    [Tags]    regression    api    basket    security
    Assert Basket Modification Without Authentication Is Rejected

#API-BASKET-012
Access Another User's Basket
    [Tags]    regression, api, basket, broken-access-control
    Assert Users Cannot Access Other User's Basket