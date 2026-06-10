# Direct Database Testing - OWASP Juice Shop

## Overview

Direct database validation was implemented using **Robot Framework** and **DatabaseLibrary** against a **SQLite** database to verify data integrity, persistence, security, and query performance.

## Covered Database Test Cases

| ID              | Validation                                                   | Status |
| --------------- | ------------------------------------------------------------ | ------ |
| DB-USER-001     | Verify user creation after registration and password hashing | ✅      |
| DB-USER-002     | Verify duplicate email records are prevented                 | ✅      |
| DB-PROD-001     | Validate product records and data consistency                | ✅      |
| DB-PROD-002     | Verify product data modification is correctly persisted      | ✅      |
| DB-BASKET-001   | Verify product addition and quantity update in basket        | ✅      |
| DB-BASKET-002   | Verify basket item removal                                   | ✅      |
| DB-FEEDBACK-001 | Verify feedback creation, modification, and deletion         | ✅      |
| DB-PERF-001     | Measure product query execution performance                  | ✅      |
| DB-PERF-002     | Validate user lookup query response time and stability       | ✅      |
| DB-PERF-003     | Measure basket join query performance                        | ✅      |
| DB-SEC-001      | Verify passwords are stored securely and not in plaintext    | ✅      |

## Validation Areas

* **Data Persistence:** Insert, update, and delete operations.
* **Data Integrity:** Duplicate prevention and relationship consistency.
* **Performance:** Query execution time and repeated query stability.
* **Security:** Sensitive data storage validation.
