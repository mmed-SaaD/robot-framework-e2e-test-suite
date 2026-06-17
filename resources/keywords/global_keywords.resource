*** Settings ***
Library    SeleniumLibrary
Variables    ../../core/utils/env_loader.py
Resource    ../../resources/locators/products/products.resource
Resource    ../../resources/locators/navigation/navigation.resource

*** Keywords ***
Wait Until Initial Snackbar Disappears
    ${snackbar_exists}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    .mat-mdc-snack-bar-label.mdc-snackbar__label    2s

    IF    ${snackbar_exists}
        Wait Until Element Is Not Visible    .mat-mdc-snack-bar-label.mdc-snackbar__label    10s
    END

Close Welcome Banner
    ${welcome_banner}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${close_welcome_banner}    5s
    IF    ${welcome_banner}
        Wait Until Element Is Enabled    ${close_welcome_banner}    5s
        Click Button    ${close_welcome_banner}
        Wait Until Element Is Not Visible    ${close_welcome_banner}    5s
    END

Open Browser To Main Page
    ${headless}=    Set Variable    %{HEADLESS=false}

    ${options}=    Evaluate    sys.modules['selenium.webdriver'].EdgeOptions()    sys
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --window-size\=1920,1080
    Call Method    ${options}    add_argument    --remote-debugging-port\=9222
    Call Method    ${options}    add_argument    --disable-extensions
    Call Method    ${options}    add_argument    --disable-background-networking
    Call Method    ${options}    add_argument    --disable-software-rasterizer

    IF    '${headless}' == 'true'
        Call Method    ${options}    add_argument    --headless\=new
    ELSE
        Call Method    ${options}    add_argument    --start-maximized
    END

    Create WebDriver    Edge    options=${options}
    Go To    ${BASE_URL}

    Run Keyword And Ignore Error    Close Welcome Banner
    Run Keyword And Ignore Error    Close Cookies Message

    Wait Until Page Contains    OWASP Juice Shop    20s
    Wait Until Keyword Succeeds    30s    1s    Page Should Contain Element    ${product_card}

    Set Screenshot Directory    results

Close Browser Session
    Run Keyword And Ignore Error    Close Browser

Close Cookies Message
    ${cookies_messgae_is_visible}=    Run Keyword And Return Status    Element Should Be Visible   ${dismiss_cookies_button}
    IF    ${cookies_messgae_is_visible}
        Click Element    ${dismiss_cookies_button}
    END     