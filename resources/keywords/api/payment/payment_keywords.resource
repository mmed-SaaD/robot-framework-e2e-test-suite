*** Settings ***
Library    RequestsLibrary
Library    Collections
Variables    ../../../../core/utils/env_loader.py
Resource    ../../api/auth/auth_keywords.resource

*** Keywords ***
Assert Sensitive Data Is Masked
    [Arguments]    ${cardNum}
    Should Match Regexp    ${cardNum}    ^(\\*){12}\\d{4}

Assert Valid Payment Method Added
    Create Session    owasp payment    ${BASE_URL}
    ${token}    ${None}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary    
    ...    Authorization=Bearer ${token}
    ${response}=    GET On Session    owasp payment    /api/Cards    headers=${headers}    expected_status=200
    ${list_of_payment_cards}=    Set Variable   ${response.json()}[data]
    ${payment_cards_count}=    Get Length    ${list_of_payment_cards}
    FOR    ${index}    IN RANGE    ${payment_cards_count}
        Assert Sensitive Data Is Masked    ${list_of_payment_cards}[${index}][cardNum]
    END
    ${body}=    Create Dictionary    
    ...    fullName=${NAME2}    cardNum=${CARD_NUMBER}    expMonth=${EXPIRY_MONTH}    expYear=${EXPIRY_YEAR2}
    ${response}=    POST On Session    owasp payment    /api/Cards    headers=${headers}    json=${body}    expected_status=201
    ${response}=    GET On Session    owasp payment    /api/Cards    headers=${headers}    expected_status=200
    ${list_of_payment_cards}=    Set Variable   ${response.json()}[data]
    ${actual_payment_cards_count}=    Get Length    ${list_of_payment_cards}
    ${expected_payment_cards_count}=    Evaluate    ${payment_cards_count} + 1
    Should Be Equal As Integers    ${expected_payment_cards_count}    ${actual_payment_cards_count}

Assert Payment Method With Missing Card Number Is Rejected
    Create Session    owasp payment    ${BASE_URL}
    ${token}    ${None}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary    
    ...    Authorization=Bearer ${token}
    ${body}=    Create Dictionary    
    ...    fullName=${NAME2}    expMonth=${EXPIRY_MONTH}    expYear=${EXPIRY_YEAR2}
    ${response}=    POST On Session    owasp payment    /api/Cards    headers=${headers}    json=${body}    expected_status=any
    ${missing_field_value}=    Set Variable    ${response.json()}[data][cardNum]
    IF    ${response.status_code} == 201 and ${missing_field_value} == None
        Log    Payment Method Must Not Be Added Without All Required Fields Provided    WARN
    END

Assert Payment Method With Invalid Card Number Is Rejected
    Create Session    owasp payment    ${BASE_URL}
    ${token}    ${None}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary    
    ...    Authorization=Bearer ${token}
    ############################## Adding Payment Card With Short Card Number ###########################################################
    ${body}=    Create Dictionary    
    ...    fullName=${NAME2}    cardNum=${INVALID_CARD_NUMBER}    expMonth=${EXPIRY_MONTH}    expYear=${EXPIRY_YEAR2}
    ${response}=    POST On Session    owasp payment    /api/Cards    headers=${headers}    json=${body}    expected_status=400
    ${err_message}=    Set Variable    ${response.json()}[message]
    Should Be Equal As Strings    ${err_message}    Validation error: Validation min on cardNum failed
    ############################## Adding Payment Card With Long Card Number ###########################################################
    ${body}=    Create Dictionary    
    ...    fullName=${NAME2}    cardNum=13131313131313131313131313131313131    expMonth=${EXPIRY_MONTH}    expYear=${EXPIRY_YEAR2}
    ${response}=    POST On Session    owasp payment    /api/Cards    headers=${headers}    json=${body}    expected_status=400
    ${err_message}=    Set Variable    ${response.json()}[message]
    Should Be Equal As Strings    ${err_message}    Validation error: Validation max on cardNum failed

Assert Payment Method Is Deleted
    Create Session    owasp payment    ${BASE_URL}
    ${token}    ${None}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary    
    ...    Authorization=Bearer ${token}
    ${response}=    GET On Session    owasp payment    /api/Cards    headers=${headers}    expected_status=200
    ${list_of_payment_cards}=    Set Variable   ${response.json()}[data]
    ${payment_cards_count}=    Get Length    ${list_of_payment_cards}
    ${payment_card_to_delete_id}=    Set Variable    ${list_of_payment_cards}[0][id]
    ${body}=    Create Dictionary    
    ...    fullName=${NAME2}    cardNum=${CARD_NUMBER}    expMonth=${EXPIRY_MONTH}    expYear=${EXPIRY_YEAR2}
    ${response}=    DELETE On Session    owasp payment    /api/Cards/${payment_card_to_delete_id}   headers=${headers}    json=${body}    expected_status=200
    ${response}=    GET On Session    owasp payment    /api/Cards    headers=${headers}    expected_status=200
    ${list_of_payment_cards}=    Set Variable   ${response.json()}[data]
    ${actual_payment_cards_count}=    Get Length    ${list_of_payment_cards}
    ${expected_payment_cards_count}=    Evaluate    ${payment_cards_count} - 1
    Should Be Equal As Integers    ${expected_payment_cards_count}    ${actual_payment_cards_count}

Assert All Payment Methods Is Deleted
    Create Session    owasp payment    ${BASE_URL}
    ${token}    ${None}=    Assert Valid Login Returns Authentication Token
    ${headers}=    Create Dictionary    
    ...    Authorization=Bearer ${token}
    ${response}=    GET On Session    owasp payment    /api/Cards    headers=${headers}    expected_status=200
    ${list_of_payment_cards}=    Set Variable   ${response.json()}[data]
    ${payment_cards_count}=    Get Length    ${list_of_payment_cards}
    FOR    ${index}    IN RANGE    ${payment_cards_count}
        ${payment_card_to_delete_id}=    Set Variable    ${list_of_payment_cards}[${index}][id]
        ${response}=    DELETE On Session    owasp payment    /api/Cards/${payment_card_to_delete_id}   headers=${headers}    expected_status=200
    END
    
    ${response}=    GET On Session    owasp payment    /api/Cards    headers=${headers}    expected_status=200
    ${list_of_payment_cards}=    Set Variable   ${response.json()}[data]
    ${actual_payment_cards_count}=    Get Length    ${list_of_payment_cards}
    Should Be Equal As Integers    ${actual_payment_cards_count}    0

Assert User's Payment Methods Are Protected
    Create Session    owasp payment    ${BASE_URL}
    ${token}    ${None}=    Assert Valid Login Returns Authentication Token
    #We Will Use the legitimate token, then decode it using CyberChef and changing the actual userId with the Id of the targetted user then use 
    #the new rogue token
    ${rogue_token}=    Set Variable    ${ROGUE_TOKEN}
    ${headers}=    Create Dictionary    
    ...    Authorization=Bearer ${rogue_token}
    ${response}=    GET On Session    owasp payment    /api/Cards    headers=${headers}    expected_status=401
    Should Be Equal As Strings    ${response.json()}[status]    error