*** Settings ***
Resource    ../../resources/keywords/api/smoke/smoke_keywords.resource

*** Test Cases ***
#API-SMOKE-001    API-SMOKE-002
API Is Reachable
    [Tags]    smoke    api
    Assert API Is Reachable

#API-SMOKE-003
Login Endpoint Is Reachable
    [Tags]    smoke    api    auth
    Assert Login Endpoint Is Reachable

#API-SMOKE-004
Basket Endpoint Is Reachable For Authenticated User
    [Tags]    smoke    api    basket    auth
    Assert Basket Endpoint Is Reachable For Authenticated User

#API-SMOKE-005
Invalid Endpoint Returns Controlled Error Response
    [Tags]    smoke    api    negative
    Assert Invalid Endpoint Returns Controlled Error Message