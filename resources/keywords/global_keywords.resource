*** Settings ***
Library    SeleniumLibrary
Variables    ../../core/utils/env_loader.py
Resource    ../../resources/locators/products/products.resource

*** Keywords ***
Open Browser To Main Page
    Open Browser    ${BASE_URL}    edge   /home/wayne/msedgedriver.exe
    Maximize Browser Window
    Set Selenium Speed    .1s
    Set Screenshot Directory    artifacts/screenshots

Close Browser Session
    Close Browser

Close Cookies Message
    ${cookies_messgae_is_visible}=    Run Keyword And Return Status    Element Should Be Visible   ${dismiss_cookies_button}
    IF    ${cookies_messgae_is_visible}
        Click Element    ${dismiss_cookies_button}
    END     