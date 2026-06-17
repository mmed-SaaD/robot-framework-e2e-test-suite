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
    ${welcome_banner}=    Run Keyword And Return Status    Page Should Contain    Welcome to OWASP Juice Shop!
    IF    ${welcome_banner}
        Click Button    ${close_welcome_banner}
    END

Open Browser To Main Page
    ${headless}=    Set Variable    %{HEADLESS=false}
    
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].EdgeOptions()    sys
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --window-size\=1920,1080

    IF    '${headless}' == 'true'
        Call Method    ${options}    add_argument    --headless
    ELSE
        Call Method    ${options}    add_argument    --start-maximized
    END
    Open Browser    about:blank    Edge    options=${options}
    Go To    ${BASE_URL}

    Wait Until Initial Snackbar Disappears
    Wait Until Page Contains    OWASP Juice Shop    10s
    Close Welcome Banner
    Close Cookies Message

    Set Screenshot Directory    artifacts/screenshots

Close Browser Session
    Close Browser

Close Cookies Message
    ${cookies_messgae_is_visible}=    Run Keyword And Return Status    Element Should Be Visible   ${dismiss_cookies_button}
    IF    ${cookies_messgae_is_visible}
        Click Element    ${dismiss_cookies_button}
    END     