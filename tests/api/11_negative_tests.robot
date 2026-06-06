*** Settings ***
Resource    ../../resources/keywords/api/negative/negative_keywords.resource

*** Test Cases ***
#API-NEG-001
Endpoint Rejects Unsupported HTTP Method
    [Tags]    regression    api    negative
    Assert Endpoint Rejects Unsupported HTTP Method

#API-NEG-002
Endpoint Rejects Malformed JSON Body
    [Tags]    regression    api    negative
    Assert Endpoint Rejects Malformed JSON Body

#API-NEG-003
Endpoint Rejects Missing Required Headers If Required
    [Tags]    regression    api    negative 
    Assert Endpoint Rejects Missing Required Headers

#API-NEG-004
Endpoint Handles Very long Input Safely
    [Tags]    regression    api    negative    security
    Assert Endpoint Handles Very Long Input Safely

#API-NEG-005
Endpoint Handles Special Characters Safely
    [Tags]    regression    api    negative    security 
    Assert Endpoint Handles Special Characters Safely

#API-NEG-006
Endpoint Handles Null Values Safely
    [Tags]    regression    api    negative
    Assert Endpoint Handles Null Values Safely

#API-NEG-007
Endpoint Handles Wrong Data Types Safely
    [Tags]    regression    api    negative
    Assert Endpoint Handles Wrong Data Types Safely

#API-NEG-008
Endpoint Returns Controlled Error For Unknown Resource ID
    [Tags]    regression    api    negative
    Assert Endpoint Returns controlled Error For Unknown Resource ID
