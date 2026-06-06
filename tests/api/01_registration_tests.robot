*** Settings ***
Resource    ../../resources/keywords/api/registration/registration_keywords.resource

*** Test Cases ***
#API-REG-001
Register User With Valid Data
    [Tags]    regression    api    registration    critical
    Assert User Registration With Valid Data    ${VALID_EMAIL}

#API-REG-002
Register User With Existing Email Is Rejected
    [Tags]    regression    api    registration    negative
    Assert User Registration With Existing Email Is Rejected

#API-REG-003
Register User With Invalid Email Format Is Rejected
    [Tags]    regression    api    registration    negative
    Assert User Registration With Invalid Format Is Rejected

#API-REG-004
Register User With Missing Password Is Rejected
    [Tags]    regression    api    registration    negative
    Assert User Registration With Missing Password Is Rejected

#API-REG-005
Register User With Weak Password Is Rejected If Backend Enforces Policy
    [Tags]    regression    api    registration    validation
    Assert User Registration With Weak Passwprd Is Rejected

#API-REG-006
Register User With Missing Security Question Is Rejected
    [Tags]    regression    api    registration    negative
    Assert User Registration With Missing Security Question Is Rejected

#API-REG-007
Register User With Missing Security Answer Is Rejected
    [Tags]    regression    api    registration    negative
    Assert User Registration With Missing Security Answer Is Rejected

#API-REG-008
Registration Response Does Not Expose Sensitive Data
    [Tags]    regression    api    registration    security
    Assert Registration Response Does Not Expose Sensitive Data