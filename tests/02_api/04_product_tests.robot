*** Settings ***
Resource    ../../resources/keywords/api/product/product_keywords.resource

*** Test Cases ***
#API-PROD-001
Get All Products Returns Product List
    [Tags]    regression    api    products
    Assert All Products Fetched Successfully

#API-PROD-002
Product Response Contains Required Fields 
    [Tags]    regression    api    products    contract
    Assert Product Response Contains Required Fields

#API-PROD-003
Get Product By Valid ID Returns Correct Product
    [Tags]    regression    api    products
    Assert Product Correctly Fetched By ID

#API-PROD-004
Get Product By Invalid ID Returns Controlled Error
    [Tags]    regression    api    products    negative
    Assert Product Fetched with Invalid ID Returns Controlled Error

#API-PROD-005
Search Product By Valid Keyword Returns Matching Results
    [Tags]    regression    api    products    search
    Assert Searching Product By Valid Keyword Returns Matching Results

#API-PROD-006
Search Product With Unknown Keyword Returns Empty Or Controlled Response
    [Tags]    regression    api    product    ssearch    negative
    Assert Searching Product By Unknown Keyword Returns Empty/Controller Response

#API-PROD-007
Product Prices Are Numeric And Greater Than Zero
    [Tags]    regression    api    products    contract
    Assert Product Prices Are Numeric And Greater Than Zero

#API-PROD-008 => Checked In Test Case API-PROD-002

#API-PROD-009    API-PROD-010
Product Endpoint Handles Special Characters In Search Safely
    [Tags]    regression    api    products    security
    Assert Safe Handling Of Special Characters In Search