*** Settings ***
Library    SeleniumLibrary
Resource    ../global_keywords.resource
Resource    ../auth/auth_keywords.resource
Resource    ../smoke/smoke_keywords.resource
Resource    ../../../variables/negative/negative_variables.resource
Resource    ../../../locators/smoke/home_page.resource


*** Keywords ***
Pretest Build
    Open Browser To Main Page
    Close Cookies Message

Assert Invalid Route Redirects Safely
    Valid Log In
    Go To    ${invalid_route}
    Page Should Contain    All Products
    Element Should Be Visible    ${menu_button}
    Assert Juice List IS Visible

Assert Access To Basket Denied If Logged Out
    Go To    ${route_to_basket}
    ${anonymous_visible}=    Run Keyword And Return Status
    ...    Page Should Contain    anonymous

    IF    ${anonymous_visible}
        Log    SECURITY OBSERVATION: Basket page is accessible while logged out. Application creates an anonymous basket session instead of blocking access.    WARN
        Fail    Basket page should not be accessible while logged out
    END

Assert Access Denied To Checkout If Logged Out
    Go To    ${route_to_checkout}
    Page Should Contain    Please login to view this page.