*** Settings ***
Resource    ../../resources/keywords/db/db_keywords.resource
Suite Setup    Connect To Juice Shop DB
Suite Teardown    Disconnect From Juice Shop DB

*** Test Cases ***
#DB-USER-001
Verify User Is Created After Registration
    [Tags]    db    users
    Assert User Is Created After Registration

#DB-USER-002
Verify Duplicate Email Is Not Created
    [Tags]    db    users
    Assert Duplicated Email Is Not Accepted

#DB-PROD-001
Verify Product Records Exist
    [Tags]    db    products
    Assert Product Records Exist

#DB-PROD-002
Verify Product Data Modification
    [Tags]    db    products
    Assert Product Data Modification

#DB-BASKET-001    DB-BASKET-002
Verify Product Is Added To Basket
    [Tags]    db    basket
    Assert Product Is Added To Basket

#DB-BASKET-003
Verify Product Removal From Basket
    [Tags]    db    basket
    Assert Product Removal From Basket    33

#DB-FEEDBACK-001
Verify Feedback Is Stored
    [Tags]    db    feedback
    Assert Feedback Is Stored

#DB-FEEDBACK-002
Verify Feedback Modification
    [Tags]    db    feedback
    Assert Feedback Modification

#DB-FEEDBACK-003 
Verify Feedback Deletion
    [Tags]    db    feedback
    Assert Feedback Deletion

#DB-PERF-001
Verify Product Query Execution Time
    [Tags]    db    performance
    Assert Query Execution Time Is Within Range

#DB-PERF-002
Verify User Lookup Query Execution Time
    [Tags]    db    performance
    Assert User Lookup Query Execution Time Is Within Range

#DB-PERF-003
Verify Basket Items Join Query Performance
    [Tags]    db    performance
    Assert Basket Items Join Query Performance

#DB-PERF-004
Verify Repeated User Lookup Stability
    [Tags]    db    performance
    Assert Repeated User Lookup Stability

#DB-SEC-001
Verify Passwords Are Not Stored In Plaintext
    [Tags]    db    security
    Assert Passwords Are Not Stored In Plaintext