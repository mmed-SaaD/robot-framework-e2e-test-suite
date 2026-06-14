*** Settings ***
Resource    ../../resources/keywords/security/security_keywords.resource

*** Test Cases ***
#SEC-PATH-001   
Relative Path Traversal Sequences Are Blocked
    [Tags]    security    path-traversal
    Assert Relative Path Traversal Sequences Are Blocked

#SEC-PATH-003
Sensitive System Files Cannot Be Accessed
    [Tags]    security    path-traversal
    Assert Sensitive System Files Cannot Be Accessed

#SEC-PATH-003
Encoded Traversal Payloads Are Rejected 
    [Tags]    security    path-traversal
    Assert Encoded Path Traversal Sequences Are Blocked