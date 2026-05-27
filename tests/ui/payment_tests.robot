*** Settings ***
Resource    ../../resources/keywords/global_keywords.resource
Resource    ../../resources/keywords/ui/payment/payment_keywords.resource
Test Setup    payment_keywords.Pretest Build
Test Teardown    Close All Browsers

*** Test Cases ***
#UI-PAY-001 
Open Saved Payment Options
    [Tags]    regression    ui    payment
    Assert Saved Payment Options Page Opens Successfully

#UI-PAY-002
Add New Payment Method
    [Tags]    regression    ui    payment
    Assert New Payment Method Added

#UI-PAY-003
Validate Missing Card Fields
    [Tags]    regression    ui    payment    negative
    Assert New Card With Missing Fields

#UI-PAY-004
Validate Invalid Card Number
    [Tags]    regression    ui    payment    negative
    Assert New Card With Invalid Card Number

#UI-PAY-005 
Select Payment During Checkout
    [Tags]    regression    ui    payment    checkout
    Assert New Payment Method Selected During Checkout

#UI-PAY-006
Delete Saved Payment Method
    [Tags]    regression    ui    payment
    Assert Payment Method Deletion