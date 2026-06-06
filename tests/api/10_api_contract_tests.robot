*** Settings ***
Resource    ../../resources/keywords/api/api_contract/api_contract_keywords.resource

*** Test Cases ***
#API-CONTRACT-001
Successful Responses Use Expected JSON Format
    [Tags]    regression    api    contract
    Assert Successfull Responses Use JSON Format

#API-CONTRACT-002
Error Responses Use Consistent Structure
    [Tags]    regression    api    contract    negative
    Assert Error Responses Use Consistent Structure

#API-CONTRACT-003
Required Fields Are Present In Product Responses
    [Tags]    regression    api    contract    products
    Assert Required Fields Are Present In Product Responses

#API-CONTRACT-004
Required Fields Are Present In Basket Responses
    [Tags]    regression    api    contract    products
    Assert Required Fields Are Present In Basket Responses

#API-CONTRACT-005
Required Fields Are Present In Order Responses
    [Tags]    regression    api    contract    checkout
    Assert Required Fields Are Present In Order Responses

#API-CONTRACT-006
Numeric Fields Use Correct Data Types
    [Tags]    regression    api    contract
    Assert Numeric Fields Use Correct Data Types

#API-CONTRACT-007
Date Fields Use Expected Format Where Applicable
    [Tags]    regression    api    contract
    Assert Date Fields Use Expected Format
