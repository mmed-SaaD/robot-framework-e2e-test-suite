*** Settings ***
Library    RequestsLibrary
Library    Collections
Variables    ../../../../core/utils/env_loader.py
Resource    ../../api/auth/auth_keywords.resource
Resource    ../../api/basket/basket_keywords.resource
Resource    ../../../variables/api_contract/api_contract_variables.resource

*** Keywords ***
Session Setup
    Create Session    owasp api contract    ${BASE_URL}
    ${token}    ${basket_id}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary        
    ...    Authorization=Bearer ${token}
    RETURN    ${token}    ${headers}    ${basket_id}

Assert Successfull Responses Use JSON Format
    #List products
    ${token}    ${headers}    ${None}=    Session Setup
    ${response}=    GET On Session    owasp api contract    /api/Products    expected_status=200
    ${products_list}=    Set Variable    ${response.json()}[data]
    ${products_count}=    Get Length    ${products_list}
    Should Be Equal As Integers    ${products_count}    36
    Should Contain    ${response.headers}[Content-Type]    application/json

Assert Error Responses Use Consistent Structure
    ${token}    ${headers}    ${None}=    Session Setup
    ${body}=    Create Dictionary    
    ...    fullName=${NAME}    mobileNum=${INVALID_PHONE_NUMBER}    zipCode=${ZIP}    
    ...    streetAddress=${ADDRESS}    city=${CITY}    country=${COUNTRY}
        ${response}=    POST On Session    owasp api contract     /api/Addresss    headers=${headers}    json=${body}    expected_status=400
        Should Contain    ${response.headers}[Content-Type]    application/json
        Dictionary Should Contain Key    ${response.json()}    message
        Dictionary Should Contain Key    ${response.json()}    errors
        ${err_message}=    Set Variable    ${response.json()}[message]
        Should Contain    ${err_message}    Validation error: Validation max on mobileNum failed

Assert Required Fields Are Present In Product Responses
    ${token}    ${headers}    ${None}=    Session Setup
    ${response}=    GET On Session    owasp api contract    /api/Products    expected_status=200
    ${products_list}=    Set Variable    ${response.json()}[data]
    ${products_count}=    Get Length    ${products_list}
    Should Be Equal As Integers    ${products_count}    36
    Should Contain    ${response.headers}[Content-Type]    application/json
    FOR    ${index}    IN RANGE    ${products_count}
        FOR    ${field}    IN    @{products_fields}
           Dictionary Should Contain Key    ${response.json()}[data][${index}]    ${field} 
        END
    END

Assert Required Fields Are Present In Basket Responses
    ${token}    ${headers}    ${basket_id}=    Session Setup
    Assert Valid Product Added To Basket
    ${response}=    GET On Session    owasp api contract    /rest/basket/${basket_id}    expected_status=200    headers=${headers}
    ${basket_products}=    Set Variable    ${response.json()}[data]
        FOR    ${field}    IN    @{basket_fields}
           Dictionary Should Contain Key    ${basket_products}    ${field} 
        END

Assert Required Fields Are Present In Order Responses
    ${token}    ${headers}    ${None}=    Session Setup
    ${response}=    GET On Session    owasp api contract    /rest/order-history    headers=${headers}    expected_status=200
    ${list_of_orders}=    Set Variable    ${response.json()}[data]
    Should Not Be Empty    ${list_of_orders}    msg=No order placed yet !
    ${previous_order_count}=    Get Length    ${list_of_orders}
    FOR    ${index}    IN RANGE    ${previous_order_count}
        FOR    ${field}    IN    @{order_fields}
           Dictionary Should Contain Key    ${list_of_orders}[${index}]    ${field} 
        END
    END

Assert Numeric Fields Use Correct Data Types
    ${token}    ${headers}    ${None}=    Session Setup
    ${response}=    GET On Session    owasp api contract    /api/Products    expected_status=200
    ${products_list}=    Set Variable    ${response.json()}[data]
    ${products_count}=    Get Length    ${products_list}
    Should Be Equal As Integers    ${products_count}    36
    Should Contain    ${response.headers}[Content-Type]    application/json
    FOR    ${index}    IN RANGE    ${products_count}
        Should Be True    isinstance(${products_list}[${index}][price] , (int, float))
    END

Assert Date Fields Use Expected Format
    ${token}    ${headers}    ${None}=    Session Setup
    ${response}=    GET On Session    owasp api contract    /api/Products    expected_status=200
    ${products_list}=    Set Variable    ${response.json()}[data]
    ${products_count}=    Get Length    ${products_list}
    Should Be Equal As Integers    ${products_count}    36
    Should Contain    ${response.headers}[Content-Type]    application/json
    FOR    ${index}    IN RANGE    ${products_count}
        Should Match Regexp
        ...    ${products_list}[${index}][createdAt]
        ...    ^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z$

        Should Match Regexp
        ...    ${products_list}[${index}][updatedAt]
        ...    ^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z$
    END

    