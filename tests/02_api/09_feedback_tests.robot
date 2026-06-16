*** Settings ***
Resource    ../../resources/keywords/api/feedback/feedback_keywords.resource

*** Test Cases ***
#API-FEED-001    API-FEED-002
Submit Valid Feedback
    [Tags]    regression    api    feedback
    Assert Valid Feedback Submission

#API-FEED-003
Submit Feedback With Empty Comment Is Rejected
    [Tags]    regression    api    feedback    negative
    Assert Feedback With Empty Comment Is Rejected

#API-FEED-004 
Submit Feedback With Invalid Rating Is Rejected
    [Tags]    regression    api    feedback    negative
    Assert Feedback With Invalid Rating Is Rejected

#API-FEED-005
Submit Feedback Without Captcha Answer Is Rejected If Required
    [Tags]    regression    api    feedback    validation
    Assert Feedback Without Captcha Answer Is Rejected

#API-FEED-006
Submit Feedback With Script Payload Is Safely Handled
    [Tags]    regression    api    feedback    security
    Assert Feedback With Script Payload Is Safely Handled

#API-FEED-007
Feedback Endpoint Does Not Expose Internal Server Errors
    [Tags]    regression    api    feedback    security
    Assert Feedback Endpoint Does Not Expose Internal Server Errors