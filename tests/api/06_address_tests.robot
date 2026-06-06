*** Settings ***
Resource    ../../resources/keywords/api/address/address_keywords.resource

*** Test Cases ***
#API-ADDR-001    API-ADDR-002    API-ADDR-003
Create Address With Valid Data
    [Tags]    regression    api    address
    Assert Address Creation With Valid Data

#API-ADDR-004
Create Address With Missing Required Fields Is Rejected
    [Tags]    regression    api    address    negative 
    Assert Address Creation With Missing Required Fields May Be Rejected

#API-ADDR-005
Create Address With Invalid Phone Number Is Rejected 
    [Tags]    regression    api    address    validation
    Assert Address Creation May Be Rejected With Invalid Phone Number

#API-ADDR-006    API-ADDR-007
Delete Saved Address
    [Tags]    regression    api    address
    Assert Saved Address Deletion
    Assert All Saved Addresses Deletion