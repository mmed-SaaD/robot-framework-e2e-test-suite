*** Settings ***
Library    DatabaseLibrary
Library    Collections
Library    DateTime
Resource    ../../variables/db/db_variables.resource

*** Keywords ***
Connect To Juice Shop DB
    Connect To Database    sqlite3    ${DB_PATH}

Disconnect From Juice Shop DB
    Disconnect From Database

Assert User Is Created After Registration
    [Arguments]    ${email}=${VALID_EMAIL}
    @{params}=    Create List    ${email}
    ${result}=    Query    
    ...    SELECT COUNT(*) FROM Users WHERE email = ?    
    ...    parameters=${params}
    Should Not Be Equal As Integers    ${result}[0][0]    0

Assert Duplicated Email Is Not Accepted
    [Arguments]    ${email}=${VALID_EMAIL}
    @{params}=    Create List    ${email}
    ${result}=    Query    
    ...    SELECT COUNT(*) FROM Users WHERE email = ?    
    ...    parameters=${params}
    Should Be Equal As Integers    ${result}[0][0]    1

Assert Product Records Exist
    ${products_rows}=    Query    SELECT name,description,price FROM Products;
    FOR    ${row}    IN    @{products_rows}
        Should Not Be Empty    ${row}[0]
        Should Not Be Empty    ${row}[1]
        Should Be True    ${row}[2] > 0
    END

Assert Product Data Modification
    ${params}=    Create List    7

    ${original_product_data}=    Query
    ...    SELECT id, name, description, price FROM Products WHERE id = ?
    ...    parameters=${params}

    ${timestamp}=    Get Time    epoch
    ${new_product_name}=    Set Variable    The Dark Knight Rises Suit ${timestamp}

    Insert Into List    ${params}    0    value=${new_product_name}

    Execute Sql String
    ...    UPDATE Products SET name = ? WHERE id = ?
    ...    parameters=${params}

    Remove From List    ${params}    0

    ${new_product_data}=    Query
    ...    SELECT id, name, description, price FROM Products WHERE id = ?
    ...    parameters=${params}

    Should Not Be Equal As Strings
    ...    ${original_product_data}[0][1]
    ...    ${new_product_data}[0][1]

    Should Be Equal As Strings
    ...    ${new_product_data}[0][1]
    ...    ${new_product_name}

    Should Be Equal As Integers
    ...    ${original_product_data}[0][0]
    ...    ${new_product_data}[0][0]


Assert Product Is Added To Basket
    #We Will use the userId 23 and the basket id 6, plus we will be adding the product with the id 17
    ${iteration}=    Set Variable    0
    ${params}=    Create List    2    33
    ${basket_id}=    Create List    6
    ${previous_available_basketItems}=    Query    SELECT ProductId, BasketId, quantity FROM BasketItems WHERE BasketId = ?    parameters=${basket_id}
    FOR    ${item}    IN    @{previous_available_basketItems}
        IF    ${item}[0]==${params}[1]
            ${quantity} =    Set Variable     ${item}[2]
            IF    ${item}[2] < 5
                WHILE    ${quantity} < 5 and ${iteration} < ${params}[0]
                    ${quantity}=    Evaluate    ${quantity} + 1 
                    ${iteration}=    Evaluate    ${iteration} + 1 
                END
                IF    ${quantity} == 0
                    ${quantity}=    Set Variable    ${item}[2]   
                END
                Log To Console    ${quantity}
               ${updatedAt}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
               ${update_params}=    Create List    ${quantity}    ${updatedAt}    ${params}[1]    ${basket_id}[0]
               Execute Sql String    UPDATE BasketItems SET quantity = ? ,updatedAt = ? WHERE ProductId = ? AND BasketId = ?     parameters=${update_params}
               RETURN
            ELSE
                Log To Console    message=You cannot order more than 5 items of this product !
                RETURN
            END  
        END
    END
    ${createdAt}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${updatedAt}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${update_params}=    Create List    ${params}[1]    ${basket_id}[0]    ${params}[0]    ${createdAt}    ${updatedAt}
    Execute Sql String    INSERT INTO BasketItems(ProductId, BasketId, quantity, createdAt, updatedAt) VALUES(?, ?, ?, ?, ?)    parameters=${update_params}

Assert Product Removal From Basket
    [Arguments]    ${product_id}
    ${product_id}=    Create List    ${product_id}
    ${result}=    Query    SELECT COUNT(ProductId) FROM BasketItems WHERE ProductId = ?    parameters=${product_id}
    IF    ${result}[0][0] == 1
        Execute Sql String    DELETE FROM BasketItems WHERE ProductId = ?    parameters=${product_id}
        ${result}=    Query    SELECT COUNT(ProductId) FROM BasketItems WHERE ProductId = ?    parameters=${product_id}
        Should Be Equal As Integers    ${result}[0][0]    0
    ELSE
        Log To Console    Product Not found in basket !  
        RETURN
    END

Assert Feedback Is Stored
    #We Will use The userId 23.
    ${createdAt}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${updatedAt}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${params}=    Create List    23    ${comment}    ${rating}    ${createdAt}    ${updatedAt}
    ${temp_params}=    Create List    23    ${comment}
    ${fetched_records}=    Query    SELECT comment, rating FROM Feedbacks WHERE userId = ? AND comment = ?    parameters=${temp_params}
    ${fetched_records_count}=    Get Length    ${fetched_records}
    IF    ${fetched_records_count} == 0
        Execute Sql String    INSERT INTO Feedbacks(userId, comment, rating, createdAt, updatedAt) VALUES(?,?,?,?,?)    parameters=${params}
        Remove From List    ${params}    4
        Remove From List    ${params}    3
        Remove From List    ${params}    2
        ${fetched_records}=    Query    SELECT comment, rating FROM Feedbacks WHERE userId = ? AND comment = ?    parameters=${params}
        ${fetched_records_count}=    Get Length    ${fetched_records}
        Should Be Equal As Integers    ${fetched_records_count}    1
    ELSE
        Log To Console    A similar comment already exists !
        RETURN
    END

Assert Feedback Modification
    ${new_comment}=    Set Variable    This app is so good i had to rewrite my comment to be fair !!!!!
    ${updatedAt}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${temp_params}=    Create List    23    ${comment}
    ${params}=    Create List    ${new_comment}    ${updatedAt}    23    ${comment}
    ${fetched_records}=    Query    SELECT comment, rating FROM Feedbacks WHERE userId = ? AND comment = ?    parameters=${temp_params}
    ${fetched_records_count}=    Get Length    ${fetched_records}
    IF    ${fetched_records_count} == 0
        Log    No similar comment found !    WARN
        RETURN
    ELSE
            Remove From List    ${temp_params}    1
            Append To List    ${temp_params}    ${new_comment}
            ${fetched_updated_records}=    Query    SELECT comment, rating FROM Feedbacks WHERE userId = ? AND comment = ?    parameters=${temp_params}
            ${fetched_updated_records_count}=    Get Length    ${fetched_updated_records}
            IF    ${fetched_updated_records_count} >= 1
                Log    Similar Comment Already exists !    WARN
                RETURN
            END            
            Execute Sql String    UPDATE Feedbacks SET comment=?, updatedAt=? WHERE userId = ? AND comment = ?    parameters=${params}
            Remove From List    ${params}    3
            Remove From List    ${params}    1
            ${fetched_records}=    Query    SELECT comment, rating FROM Feedbacks WHERE comment = ? AND userId = ?  parameters=${params}
            ${fetched_records_count}=    Get Length    ${fetched_records}
            Should Be Equal As Integers    ${fetched_records_count}    1 
            Should Not Be Equal As Strings    ${fetched_records}[0][0]    ${comment}
    END
    
Assert Feedback Deletion
    ${result}=    Query    SELECT * FROM Feedbacks
    ${new_comment}=    Set Variable    This app is so good i had to rewrite my comment to be fair !!!!!
    ${params}=    Create List    23    ${new_comment}
    ${fetched_records}=    Query    SELECT comment, rating FROM Feedbacks WHERE userId = ? AND comment = ?    parameters=${params}
    ${fetched_records_count}=    Get Length    ${fetched_records}
    Should Not Be Equal As Integers    ${fetched_records_count}    0
    Execute Sql String    DELETE FROM Feedbacks WHERE userId = ? AND comment = ?    parameters=${params}
    ${fetched_records}=    Query    SELECT comment, rating FROM Feedbacks WHERE userId = ? AND comment = ?    parameters=${params}
    ${fetched_records_count}=    Get Length    ${fetched_records}
    Should Be Equal As Integers    ${fetched_records_count}    0

Assert Query Execution Time Is Within Range
    #Threshold is <1s
    ${start_counter}=    Get Current Date    result_format=epoch
    ${rows}=    Query    SELECT id, name, price FROM Products;
    ${rows_count}=    Get Length    ${rows}
    Should Not Be Equal As Integers    ${rows_count}    0
    ${end_counter}=    Get Current Date    result_format=epoch
    ${execution_time_spent}=    Evaluate    ${end_counter} - ${start_counter}
    Should Be True    ${execution_time_spent} < 1

Assert User Lookup Query Execution Time Is Within Range
    [Arguments]    ${email}=${VALID_EMAIL}
    #Threshold is <1s
    ${params}=    Create List    ${email}
    ${start_counter}=    Get Current Date    result_format=epoch
    ${result}=    Query    SELECT COUNT(*) FROM Users WHERE email = ?    parameters=${params}
    Should Be Equal As Integers    ${result}[0][0]    1
    ${end_counter}=    Get Current Date    result_format=epoch
    ${execution_time_spent}=    Evaluate    ${end_counter} - ${start_counter}
    Should Be True    ${execution_time_spent} < 1

Assert Basket Items Join Query Performance
    #Threshold is <1s    
    ${start_counter}=    Get Current Date    result_format=epoch
    ${result}=    Query    SELECT ProductId, Baskets.id, quantity FROM BasketItems LEFT JOIN Baskets ON BasketItems.BasketId = Baskets.id
    ${result_count}=    Get Length    ${result}
    Should Not Be Equal As Integers    ${result_count}    0
    ${end_counter}=    Get Current Date    result_format=epoch
    ${execution_time_spent}=    Evaluate    ${end_counter} - ${start_counter}
    Should Be True    ${execution_time_spent} < 1

Assert Repeated User Lookup Stability
    [Arguments]    ${iterations}=6    ${email}=${VALID_EMAIL}
    ${times}=    Create List
    ${params}=    Create List    ${email}

    FOR    ${i}    IN RANGE    ${iterations}
        ${start}=    Evaluate    time.time()    time
        ${result}=    Query    SELECT id, email FROM Users WHERE email = ?    parameters=${params}
        ${end}=    Evaluate    time.time()    time
        ${execution_time}=    Evaluate    round(${end} - ${start}, 4)
        Append To List    ${times}    ${execution_time}
        Should Not Be Empty    ${result}
    END

    ${total}=    Evaluate    sum(${times})
    ${avg}=      Evaluate    round(${total} / ${iterations}, 4)
    ${max}=      Evaluate    max(${times})
    ${min}=      Evaluate    min(${times})

    Log To Console    Times: ${times}
    Log To Console    Avg: ${avg}s | Min: ${min}s | Max: ${max}s

    Should Be True    ${avg} < 1      Avg too slow: ${avg}s
    Should Be True    ${max} < 2      Spike detected: ${max}s

Assert Passwords Are Not Stored In Plaintext
    [Arguments]    ${email}=${VALID_EMAIL}
    ${params}=    Create List    ${email}
    ${result}=    Query    SELECT COUNT(*), Password FROM Users WHERE email = ?    parameters=${params}
    Should Be Equal As Integers    ${result}[0][0]    1
    Should Match Regexp    ${result}[0][1]    [a-fA-F0-9]{32}
    

    
