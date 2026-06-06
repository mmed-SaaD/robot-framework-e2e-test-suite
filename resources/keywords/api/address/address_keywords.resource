*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../../api/auth/auth_keywords.resource
Variables    ../../../../core/utils/env_loader.py

*** Keywords ***
Assert Address Creation With Valid Data
    Create Session    owasp address    ${BASE_URL}
    ${token}    ${None}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary    
    ...    Authorization=Bearer ${token}
    ${body}=    Create Dictionary    
    ...    fullName=${NAME}    mobileNum=${MOBILE_NUMBER}    zipCode=${ZIP}    
    ...    streetAddress=${ADDRESS}    city=${CITY}    country=${COUNTRY}
    ${response}=    GET On Session    owasp address    /api/Addresss    headers=${headers}    expected_status=200
    ${addresses_list}=    Set Variable    ${response.json()}[data]
    ${addresses_count}=    Get Length    ${addresses_list}
    ${response}=    POST On Session    owasp address     /api/Addresss    headers=${headers}    json=${body}    expected_status=201
    ${expected_addresses_count}=    Evaluate    ${addresses_count} + 1
    ${response}=    GET On Session    owasp address    /api/Addresss    headers=${headers}    expected_status=200
    ${actual_addresses_list}=    Set Variable    ${response.json()}[data]
    ${actual_addresses_count}=    Get Length    ${actual_addresses_list}
    Should Be Equal As Integers    ${actual_addresses_count}    ${expected_addresses_count}
    FOR    ${index}    IN RANGE    ${actual_addresses_count}
        Dictionary Should Contain Key    ${actual_addresses_list}[${index}]    fullName
        Dictionary Should Contain Key    ${actual_addresses_list}[${index}]    mobileNum
        Dictionary Should Contain Key    ${actual_addresses_list}[${index}]    zipCode
        Dictionary Should Contain Key    ${actual_addresses_list}[${index}]    streetAddress
        Dictionary Should Contain Key    ${actual_addresses_list}[${index}]    city
        Dictionary Should Contain Key    ${actual_addresses_list}[${index}]    country
        Dictionary Should Contain Key    ${actual_addresses_list}[${index}]    state

        ${added_address_status}=    Run Keyword And Return Status    Should Contain    ${actual_addresses_list}[${index}][fullName]    ${body}[fullName]    
        IF    ${added_address_status}
            Should Contain    ${actual_addresses_list}[${index}][zipCode]    ${body}[zipCode] 
            Should Contain    ${actual_addresses_list}[${index}][streetAddress]    ${body}[streetAddress]
            Should Contain    ${actual_addresses_list}[${index}][city]    ${body}[city]
            Should Contain    ${actual_addresses_list}[${index}][country]    ${body}[country]   
        END
    END

Assert Address Creation With Missing Required Fields May Be Rejected
    Create Session    owasp address    ${BASE_URL}
    ${token}    ${None}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary    
    ...    Authorization=Bearer ${token}
    ${body}=    Create Dictionary    
    ...    fullName=${NAME}    mobileNum=${MOBILE_NUMBER}    
    ...    zipCode=${ZIP}    
    ...    city=${CITY}
    ${response}=    POST On Session    owasp address     /api/Addresss    headers=${headers}    json=${body}    expected_status=any
    IF    ${response.status_code} == 201
        Log    Address is missing required field (streetAddress and country) and yet it was successfully added which should Not Happen    WARN
    END

Assert Address Creation May Be Rejected With Invalid Phone Number
    Create Session    owasp address    ${BASE_URL}
    ${token}    ${None}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary    
    ...    Authorization=Bearer ${token}
    ${body}=    Create Dictionary    
    ...    fullName=${NAME}    mobileNum=${INVALID_PHONE_NUMBER}    zipCode=${ZIP}    
    ...    streetAddress=${ADDRESS}    city=${CITY}    country=${COUNTRY}
        ${response}=    POST On Session    owasp address     /api/Addresss    headers=${headers}    json=${body}    expected_status=400
        ${err_message}=    Set Variable    ${response.json()}[message]
        Should Be Equal As Strings    ${err_message}    Validation error: Validation max on mobileNum failed

Assert Saved Address Deletion
    Create Session    owasp address    ${BASE_URL}
    ${token}    ${None}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary    
    ...    Authorization=Bearer ${token}
    ${response}=    GET On Session    owasp address    /api/Addresss    headers=${headers}    expected_status=200
    ${addresses_list}=    Set Variable    ${response.json()}[data]
    ${address_to_delete_id}=    Set Variable    ${response.json()}[data][0][id]
    ${addresses_count}=    Get Length    ${addresses_list}
    ${response}=    DELETE On Session    owasp address     /api/Addresss/${address_to_delete_id}    headers=${headers}    expected_status=200
    ${expected_addresses_count}=    Evaluate    ${addresses_count} - 1
    Should Be Equal As Strings    ${response.json()}[data]    Address deleted successfully.
    ${response}=    GET On Session    owasp address    /api/Addresss    headers=${headers}    expected_status=200
    ${actual_addresses_list}=    Set Variable    ${response.json()}[data]
    ${actual_addresses_count}=    Get Length    ${actual_addresses_list}
    Should Be Equal As Integers    ${actual_addresses_count}    ${expected_addresses_count}

Assert All Saved Addresses Deletion
    Create Session    owasp address    ${BASE_URL}
    ${token}    ${None}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary    
    ...    Authorization=Bearer ${token}
    ${response}=    GET On Session    owasp address    /api/Addresss    headers=${headers}    expected_status=200
    ${addresses_list}=    Set Variable    ${response.json()}[data]
    ${addresses_count}=    Get Length    ${addresses_list}
    FOR    ${index}    IN RANGE   ${addresses_count}
        ${address_to_delete_id}=    Set Variable    ${addresses_list}[${index}][id]
        ${response}=    DELETE On Session    owasp address     /api/Addresss/${address_to_delete_id}    headers=${headers}    expected_status=200
        Should Be Equal As Strings    ${response.json()}[data]    Address deleted successfully.
    END

    ${response}=    GET On Session    owasp address    /api/Addresss    headers=${headers}    expected_status=200
    ${actual_addresses_list}=    Set Variable    ${response.json()}[data]
    ${actual_addresses_count}=    Get Length    ${actual_addresses_list}
    Should Be Equal As Integers    ${actual_addresses_count}    0
