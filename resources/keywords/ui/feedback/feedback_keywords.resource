*** Settings ***
Library    SeleniumLibrary
Library    String
Resource    ../../../locators/smoke/home_page.resource
Resource    ../../../locators/feedback/feedback.resource
Resource    ../../global_keywords.resource
Resource    ../auth/auth_keywords.resource
Resource    ../../../variables/feedback/feedback_variables.resource

*** Keywords ***
Pretest Build
    Open Browser To Main Page
    Valid Log In
    Close Cookies Message

Assert Feedback Page Opens
    Click Button    ${menu_button}
    Wait Until Element Is Visible    ${feedback_link}
    Click Element    ${feedback_link}
    Page Should Contain    Customer Feedback

Set Rating Slider Value
    [Arguments]    ${value}

    ${slider}=    Set Variable    css=input[type="range"][matsliderthumb]
    Press Keys    NONE    TAB
    Press Keys    NONE    HOME

    FOR    ${i}    IN RANGE    1    ${value}
        Press Keys    NONE    ARROW_RIGHT
    END

    Element Attribute Value Should Be
    ...    ${slider}
    ...    aria-valuetext
    ...    ${value}★

Assert Valid Feedback Submitted 
    Assert Feedback Page Opens
    Input Text    ${comment_area}    ${comment}
    Set Rating Slider Value    ${rating}
    ${captcha_question}=    Get Text    ${captcha}
    ${captcha_answer}=    Evaluate    ${captcha_question}
    Input Text    ${captcha_input}    ${captcha_answer}
    Wait Until Element Is Enabled    ${submit_feedback_button}
    Click Button    ${submit_feedback_button}
    Page Should Contain    Thank you for your feedback.


Assert Empty Feedback Not Submitted
    Assert Feedback Page Opens
    Input Text    ${comment_area}    text=
    Click Element    ${rating_slider}
    ${captcha_question}=    Get Text    ${captcha}
    ${captcha_answer}=    Evaluate    ${captcha_question}
    Input Text    ${captcha_input}    ${captcha_answer}
    Page Should Contain    Please provide a comment.
    Element Should Be Disabled    ${submit_feedback_button}