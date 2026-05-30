*** Settings ***
Library    RequestsLibrary
Library    Collections
Variables    ../../../../core/utils/env_loader.py

*** Keywords ***
Assert All Products Fetched Successfully
    Create Session    owasp product    ${BASE_URL}
    ${response}=    GET On Session    owasp product    /api/Products    expected_status=200
    ${products_list}=    Set Variable    ${response.json()}[data]
    ${products_count}=    Get Length    ${products_list}
    Should Be Equal As Integers    ${products_count}    36
    RETURN    ${products_list}

Assert Product Response Contains Required Fields
    @{products_list}=    Assert All Products Fetched Successfully
    FOR    ${product}    IN    @{products_list}
        Dictionary Should Contain Key    ${product}    id
        Dictionary Should Contain Key    ${product}    name
        Dictionary Should Contain Key    ${product}    description
        Dictionary Should Contain Key    ${product}    price
        Dictionary Should Contain Key    ${product}    deluxePrice
        Dictionary Should Contain Key    ${product}    image
    END

Assert Product Correctly Fetched By ID
    [Arguments]    ${product_id}=7
    Create Session    owasp product    ${BASE_URL}
    ${response}=    GET On Session    owasp product    /api/Products/${product_id}    expected_status=200
    Should Not Be Empty    ${response.json()}[data]
    Dictionary Should Contain Key    ${response.json()}[data]    id
    Should Be Equal As Integers    ${response.json()}[data][id]    ${product_id}

Assert Product Fetched with Invalid ID Returns Controlled Error
    [Arguments]    ${product_id}=1007
    Create Session    owasp product    ${BASE_URL}
    ${response}=    GET On Session    owasp product    /api/Products/${product_id}    expected_status=404
    Should Contain    ${response.json()}[message]    Not Found    

Assert Searching Product By Valid Keyword Returns Matching Results
    [Arguments]    ${search_keyword}=Melon Bike
    Create Session    owasp product    ${BASE_URL}
    ${response}=    GET On Session    owasp product    url=/rest/products/search    params=q=${search_keyword}    expected_status=200
    Should Not Be Empty    ${response.json()}[data]
    ${search_result_info}=    Set Variable    ${response.json()}[data][0]
    Should Contain    ${search_result_info}[name]    ${search_keyword}

Assert Searching Product By Unknown Keyword Returns Empty/Controller Response
    [Arguments]    ${search_keyword}=Unknown Search Keyword
    Create Session    owasp product    ${BASE_URL}
    ${response}=    GET On Session    owasp product    url=/rest/products/search?q=${search_keyword}    expected_status=200
    Should Be Empty    ${response.json()}[data]

Assert Product Prices Are Numeric And Greater Than Zero
    @{products_list}=    Assert All Products Fetched Successfully
    FOR    ${product}    IN    @{products_list}
        Should Be True    isinstance(${product}[price], (float, int))
        Should Be True    ${product}[price] > 0
    END

Assert Safe Handling Of Special Characters In Search
    ${special_inputs}=    Create List    '    "    <>    {}    %    _    --    ; DROP TABLE
    ...    ' OR '1'='1    ../../../../etc/passwd    <script>alert(1)</script>
    Create Session    owasp product    ${BASE_URL}
    FOR    ${input}    IN    @{special_inputs}
        ${search_keyword}=    Set Variable    ${input}
        ${response}=    GET On Session    owasp product    url=/rest/products/search    params=q=${search_keyword}    expected_status=any
        Should Not Be Equal As Integers    ${response.status_code}    500
        Should Not Contain    ${response.text}    SequelizeDatabaseError
        Should Not Contain    ${response.text}    TypeError: Cannot read property...
        Should Not Contain    ${response.text}    SQL syntax near...
        Should Not Contain    ${response.text}    stack trace...
        Should Not Contain    ${response.text}    file paths...
    END