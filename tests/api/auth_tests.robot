*** Settings ***
Resource    ../../resources/keywords/api/auth/auth_keywords.resource

*** Test Cases ***
#API-AUTH-001
Login With Valid Credentials Returns Authentication Token 
    [Tags]    regression    api    auth    critical
    Assert Valid Login Returns Authentication Token

#API-AUTH-002
Login With Invalid Email Is Rejected
    [Tags]    regression    api    auth    negative
    Assert Login With Invalid Email Is Rejected

#API-AUTH-003
Login With Invalid Password Is Rejected
    [Tags]    regression    api    auth    negative
    Assert Login With Invalid Password Is Rejected

#API-AUTH-004
Login With Empty Request Body Is Rejected
    [Tags]    regression    api    auth    negative
    Assert Login With Empty Request Is Rejected

#API-AUTH-005
Login With Missing Email Field Is Rejected
    [Tags]    regression    api    auth    negative
    Assert Login With Missing Email Field Is Rejected

#API-AUTH-006
Login With Missing Password Field Is Rejected
    [Tags]    regression    api    auth    negative
    Assert Login With Missing Password Field Is Rejected

#API-AUTH-007
Authenticated Request Succeeds With Valid Token
    [Tags]    regression    api    auth    token
    Assert Authenticated Request Succeeds With Valid Token

#API-AUTH-008
Authenticated Request Fails Without Token
    [Tags]    regression    api    auth    security
    Assert Authenticated Request Fails Without Token

#API-AUTH-009
Authenticated Request Triggers Error With Invalid Token
    [Tags]    regression    api    auth    security
    Assert Invalid JWT Token Triggers Server Error

#API-AUTH-010
Authenticated Request Fails With Malformed Token
    [Tags]    regression    api    auth    security
    Assert Authenticated Request Fails With Malformed Token