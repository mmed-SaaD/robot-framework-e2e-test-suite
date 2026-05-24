*** Settings ***
Resource    ../../resources/keywords/address_management/address_management_keywords.resource
Test Setup    address_management_keywords.Pretest Build
Test Teardown    Close Browser Session

*** Test Cases ***
#UI-ADDR-001
Open Saved Addresses Page 
    [Tags]    regression    ui    address
    Assert Saved Addresses Page Opens

#UI-ADDR-002 
Add Valid Address 
    [Tags]    regression    ui    address 
    Assert Valid Address Added

#UI-ADDR-003
Add Address With Missing Required Fields
    [Tags]    regression    ui    address    negative
    Assert Invalid Address Handled - Missing Required Fields

#UI-ADDR-004
Edit Address
    [Tags]    regression    ui    address
    Assert Address Updated Successfully

#UI-ADDR-005 
Delete Address
    [Tags]    regression    ui    address
    Assert Address Deletion

#UI-ADDR-006
Address Appears During Checkout 
    [Tags]    regression    ui    address    checkout
    Assert Added Addresses Appear During Checkout