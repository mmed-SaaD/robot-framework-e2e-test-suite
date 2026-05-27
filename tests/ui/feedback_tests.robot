*** Settings ***
Resource    ../../resources/keywords/ui/feedback/feedback_keywords.resource
Test Setup    feedback_keywords.Pretest Build
Test Teardown    Close All Browsers

*** Test Cases ***
#UI-FEED-001
Open Feedback Page
    [Tags]    regression    ui    feedback
    Assert Feedback Page Opens

#UI-FEED-002    UI-FEED-004    UI-FEED-005
Submit Valid Feedback
    [Tags]    regression    ui    feedback
    Assert Valid Feedback Submitted 

#UI-FEED-003
Submit Empty Feedback
    [Tags]    regression    ui    feedback    negative
    Assert Empty Feedback Not Submitted