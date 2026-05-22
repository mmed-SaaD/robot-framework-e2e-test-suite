*** Settings ***
Resource    ../../resources/keywords/global_keywords.resource
Resource    ../../resources/keywords/products/products_keywords.resource
Test Setup  Pretest Build    
Test Teardown  Close Browser Session

*** Test Cases ***
#UI-PROD-001
Products Are Displayed
    [Tags]    regression    ui    products 
    Assert Products Are Visible

#UI-PROD-002
Products Names Are Displayed
    [Tags]    regression    ui    products 
    Assert Products Names Are Visible

#UI-PROD-003
Products Images Are Displayed
    [Tags]    regression    ui    products
    Assert Products Images Are Visible

#UI-PROD-004
Products Prices Are Visible
    [Tags]    regression    ui    products
    Assert Products Prices Are Visible

#UI-PROD-005
Products Cards Open Details
    [Tags]    regression    ui    products
    Assert Products Cards Open Details

#UI-PROD-006
Search Product By Valid Name
    [Tags]    regression    ui    products    search
    Assert Products Search By Valid Name Is Functional

#UI-PROD-007
Search Product With No Results
    [Tags]    regression    ui    products    search    negative
    Assert Products Search With No Results

#UI-PROD-008 
Clear Search Results
    [Tags]    regression    ui    products    search
    Clear Search Input

#UI-PROD-009
Product Pagination 
    [Tags]    regression    ui    products
    Assert Product Pagination Is Functional

#UI-PROD-010
Items Per Page Selection
    [Tags]    regression    ui    products
    Assert Items Per Page Works