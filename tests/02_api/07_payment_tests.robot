*** Settings ***
Resource    ../../resources/keywords/api/payment/payment_keywords.resource

*** Test Cases ***
#API-PAY-001    API-PAY-002    API-PAY-003
Add Valid Payment Method
    [Tags]    regression    api    payment
    Assert Valid Payment Method Added

#API-PAY-004
Add Payment Method With Missing Card Number Is Rejected
    [Tags]    regression    api    payment    negative
    Assert Payment Method With Missing Card Number Is Rejected

#API-PAY-005
Add Payment Method With Invalid Card Number Is Rejected If Backend Validates It
    [Tags]    regression    api    payment    validation
    Assert Payment Method With Invalid Card Number Is Rejected

#API-PAY-006    API-PAY-007
Delete Saved Payment Method
    [Tags]    regression    api    payment
    Assert Payment Method Is Deleted
    Assert All Payment Methods Is Deleted

#API-PAY-008    API-PAY-009
Unauthorized User Accessing Other User's Payment Methods
    [Tags]    regression    api    payment    broken-access-control 
    Assert User's Payment Methods Are Protected