*** Settings ***
Library    SeleniumLibrary
Variables    ../../core/utils/env_loader.py
Resource    ../../resources/locators/products/products.resource
Resource    ../../resources/locators/navigation/navigation.resource

*** Keywords ***
Click Element Safely
    [Arguments]    ${locator}

    Wait Until Element Is Visible    ${locator}    30s
    Wait Until Element Is Enabled    ${locator}    30s
    Scroll Element Into View    ${locator}
    Sleep    300ms

    ${normal_click}=    Run Keyword And Return Status
    ...    Click Element    ${locator}

    IF    not ${normal_click}
        ${element}=    Get WebElement    ${locator}
        Execute Javascript    arguments[0].click();    ARGUMENTS    ${element}
    END

Wait Until Initial Snackbar Disappears
    ${snackbar_exists}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    .mat-mdc-snack-bar-label.mdc-snackbar__label    2s

    IF    ${snackbar_exists}
        Wait Until Element Is Not Visible    .mat-mdc-snack-bar-label.mdc-snackbar__label    10s
    END

Close Welcome Banner
    ${visible}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${close_welcome_banner}    5s

    IF    ${visible}
        Click Element Safely    ${close_welcome_banner}
    END

Open Browser To Main Page
    ${headless}=    Set Variable    %{HEADLESS=false}

    ${options}=    Evaluate    sys.modules['selenium.webdriver'].EdgeOptions()    sys
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --window-size\=1920,1080

    IF    '${headless}' == 'true'
        Call Method    ${options}    add_argument    --headless=new
    ELSE
        Call Method    ${options}    add_argument    --start-maximized
    END

    Open Browser    about:blank    Edge    options=${options}
    Go To    ${BASE_URL}

    Wait Until Page Contains    OWASP Juice Shop    30s
    Wait Until Initial Snackbar Disappears

    Close Welcome Banner
    Close Cookies Message
    Wait Until Initial Snackbar Disappears

    Set Screenshot Directory    artifacts/screenshots

Close Browser Session
    Close Browser

Close Cookies Message
    ${visible}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${dismiss_cookies_button}    5s

    IF    ${visible}
        Click Element Safely    ${dismiss_cookies_button}
    END