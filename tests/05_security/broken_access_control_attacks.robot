*** Settings ***
Resource    ../../resources/keywords/security/security_keywords.resource

*** Test Cases ***
#SEC-BAC-001    SEC-BAC-003
A user Cannot Access Another User's Private Data Nor Adminitrative Functionalities
    [Tags]    security    broken-access-control
    #In this Test Case We Will try to recover administrative private data of admin user using a regular user
    #To do so we will send a simple request, where we try to fetch all users records then keep the ones belonging to an admin
    Assert User Enumeration Vulnerability Exists

#SEC-BAC-002
A rogue user Cannot Access Another User's Resources With Tampered Token
    [Tags]    security    broken-access-control
    Assert Unauthorized Users Cannot Access Other User's Resources

#SEC-BAC-004
Direct Object Reference Manipulation Does Not Expose Unauthorized Data
    [Tags]    security    broken-access-control
    Assert Direct Object Reference Manipulation Does Not Exspose Unauthorized Data