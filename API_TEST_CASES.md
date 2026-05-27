# OWASP Juice Shop API Test Cases

## Purpose

This document defines the API test coverage for the Robot Framework freelance QA automation portfolio project against OWASP Juice Shop.

The goal is to cover realistic client-project API scenarios without repeating the same UI test cases already covered in the UI suite.

The API suite should focus on:

- Endpoint availability
- Authentication and session handling
- Authorization and access control
- Product catalogue APIs
- Basket/cart APIs
- Checkout/order APIs
- Address APIs
- Payment APIs
- Feedback APIs
- Input validation
- Negative API scenarios
- Security-focused API checks
- API contract and response validation
- End-to-end API business workflows

---

## Scope Strategy

The UI suite already verifies that users can interact with the application through the browser.

The API suite should verify what the backend actually accepts, rejects, returns, protects, and calculates.

Avoid repeating UI-only checks such as:

- Button visibility
- Page navigation
- Menu behavior
- Form layout
- Toast messages
- Browser refresh behavior
- Visual validation messages

Focus instead on:

- HTTP status codes
- Response body structure
- Required response fields
- Authentication tokens/cookies
- Authorization rules
- Data creation, update, and deletion
- Business rules
- Error handling
- Security weaknesses

---

## 1. API Smoke Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| API-SMOKE-001 | API is reachable | High | smoke, api | => Checked
| API-SMOKE-002 | Product endpoint returns successful response | High | smoke, api, products | => Checked
| API-SMOKE-003 | Login endpoint is reachable | High | smoke, api, auth | => Checked
| API-SMOKE-004 | Basket endpoint is reachable for authenticated user | High | smoke, api, basket, auth | => checked
| API-SMOKE-005 | Invalid endpoint returns controlled error response | Medium | smoke, api, negative | => Checked
NB: API-SMOKE-001 and API-SMOKE-002  are covered by the same smoke test because the product endpoint is used to verify API availability.

---

## 2. Authentication API Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| API-AUTH-001 | Login with valid credentials returns authentication token | High | regression, api, auth, critical | => Checked
| API-AUTH-002 | Login with invalid email is rejected | High | regression, api, auth, negative | => Checked
| API-AUTH-003 | Login with invalid password is rejected | High | regression, api, auth, negative | => Checked
| API-AUTH-004 | Login with empty request body is rejected | High | regression, api, auth, negative | => Checked
| API-AUTH-005 | Login with missing email field is rejected | High | regression, api, auth, negative | => Checked
| API-AUTH-006 | Login with missing password field is rejected | High | regression, api, auth, negative | => Checked
| API-AUTH-007 | Authenticated request succeeds with valid token | High | regression, api, auth, token | => Checked
| API-AUTH-008 | Authenticated request fails without token | High | regression, api, auth, security | => Checked
| API-AUTH-009 | Authenticated Request Triggers Error With Invalid Token | High | regression, api, auth, security | => Checked
| API-AUTH-010 | Authenticated request fails with malformed token | Medium | regression, api, auth, negative | => Checked
---

## 3. Registration API Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| API-REG-001 | Register user with valid data | High | regression, api, registration, critical |
| API-REG-002 | Register user with existing email is rejected | High | regression, api, registration, negative |
| API-REG-003 | Register user with invalid email format is rejected | Medium | regression, api, registration, negative |
| API-REG-004 | Register user with missing password is rejected | High | regression, api, registration, negative |
| API-REG-005 | Register user with weak password is rejected if backend enforces policy | Medium | regression, api, registration, validation |
| API-REG-006 | Register user with missing security question is rejected | Medium | regression, api, registration, negative |
| API-REG-007 | Register user with missing security answer is rejected | Medium | regression, api, registration, negative |
| API-REG-008 | Registration response does not expose sensitive data | High | regression, api, registration, security |

NB: Keep only one strong happy-path registration test. Most value comes from validation and security checks.

---

## 4. Product Catalogue API Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| API-PROD-001 | Get all products returns product list | High | regression, api, products |
| API-PROD-002 | Product response contains required fields | High | regression, api, products, contract |
| API-PROD-003 | Get product by valid ID returns correct product | High | regression, api, products |
| API-PROD-004 | Get product by invalid ID returns controlled error | Medium | regression, api, products, negative |
| API-PROD-005 | Search product by valid keyword returns matching results | High | regression, api, products, search |
| API-PROD-006 | Search product with unknown keyword returns empty or controlled response | Medium | regression, api, products, search, negative |
| API-PROD-007 | Product prices are numeric and greater than zero | High | regression, api, products, contract |
| API-PROD-008 | Product image field is present in product response | Medium | regression, api, products, contract |
| API-PROD-009 | Product endpoint handles special characters in search safely | High | regression, api, products, security |
| API-PROD-010 | Product endpoint does not expose internal server errors | High | regression, api, products, security |

NB: UI already checks product visibility. API checks should focus on data quality, contract, search behavior, and backend resilience.

---

## 5. Basket / Cart API Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| API-BASKET-001 | Create or access basket for authenticated user | High | regression, api, basket, critical |
| API-BASKET-002 | Add valid product to basket | High | regression, api, basket, critical |
| API-BASKET-003 | Basket response contains added product | High | regression, api, basket |
| API-BASKET-004 | Add same product twice updates quantity or creates expected basket item behavior | High | regression, api, basket |
| API-BASKET-005 | Increase basket item quantity | Medium | regression, api, basket |
| API-BASKET-006 | Decrease basket item quantity | Medium | regression, api, basket |
| API-BASKET-007 | Remove basket item | High | regression, api, basket |
| API-BASKET-008 | Basket total is calculated correctly | High | regression, api, basket, critical |
| API-BASKET-009 | Add invalid product ID to basket is rejected | High | regression, api, basket, negative |
| API-BASKET-010 | Add product with invalid quantity is rejected | High | regression, api, basket, negative |
| API-BASKET-011 | Basket cannot be modified without authentication | High | regression, api, basket, security |
| API-BASKET-012 | User cannot access another user basket by changing basket ID | High | regression, api, basket, broken-access-control |

NB: API-BASKET-012 is very important for portfolio value because it demonstrates access-control testing, not just happy-path automation.

---

## 6. Checkout / Order API Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| API-CHECKOUT-001 | Authenticated user can place order with valid basket, address, delivery, and payment data | High | regression, api, checkout, critical |
| API-CHECKOUT-002 | Checkout fails with empty basket | High | regression, api, checkout, negative |
| API-CHECKOUT-003 | Checkout fails without valid address | High | regression, api, checkout, negative |
| API-CHECKOUT-004 | Checkout fails without valid delivery method | High | regression, api, checkout, negative |
| API-CHECKOUT-005 | Checkout fails without valid payment method | High | regression, api, checkout, negative |
| API-CHECKOUT-006 | Order summary values match basket values | High | regression, api, checkout, contract |
| API-CHECKOUT-007 | Order confirmation response contains order ID or confirmation data | High | regression, api, checkout, contract |
| API-CHECKOUT-008 | Basket is cleared or updated correctly after successful order | High | regression, api, checkout, basket |
| API-CHECKOUT-009 | User cannot place order for another user basket | High | regression, api, checkout, broken-access-control |
| API-CHECKOUT-010 | Checkout endpoint rejects tampered price or quantity data | High | regression, api, checkout, security |

NB: Do not automate every checkout UI step again. One API happy path plus strong negative and tampering checks is enough.

---

## 7. Address API Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| API-ADDR-001 | Create address with valid data | High | regression, api, address |
| API-ADDR-002 | Get saved addresses for authenticated user | High | regression, api, address |
| API-ADDR-003 | Address response contains required fields | Medium | regression, api, address, contract |
| API-ADDR-004 | Create address with missing required fields is rejected | High | regression, api, address, negative |
| API-ADDR-005 | Create address with invalid phone number is rejected if backend validates it | Medium | regression, api, address, validation |
| API-ADDR-006 | Delete saved address | Medium | regression, api, address |
| API-ADDR-007 | Deleted address no longer appears in address list | Medium | regression, api, address |
| API-ADDR-008 | User cannot access another user address | High | regression, api, address, broken-access-control |
| API-ADDR-009 | User cannot delete another user address | High | regression, api, address, broken-access-control |

---

## 8. Payment API Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| API-PAY-001 | Add valid payment method | High | regression, api, payment |
| API-PAY-002 | Get saved payment methods for authenticated user | High | regression, api, payment |
| API-PAY-003 | Payment response masks sensitive card data | High | regression, api, payment, security |
| API-PAY-004 | Add payment method with missing card number is rejected | High | regression, api, payment, negative |
| API-PAY-005 | Add payment method with invalid card number is rejected if backend validates it | High | regression, api, payment, validation |
| API-PAY-006 | Add payment method with expired date is rejected if backend validates it | Medium | regression, api, payment, validation |
| API-PAY-007 | Delete saved payment method | Medium | regression, api, payment |
| API-PAY-008 | Deleted payment method no longer appears in payment list | Medium | regression, api, payment |
| API-PAY-009 | User cannot access another user payment method | High | regression, api, payment, broken-access-control |
| API-PAY-010 | User cannot delete another user payment method | High | regression, api, payment, broken-access-control |

NB: For real client projects, payment API tests are very important because they involve sensitive data and business risk.

---

## 9. Feedback API Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| API-FEED-001 | Submit valid feedback | High | regression, api, feedback |
| API-FEED-002 | Feedback response contains created feedback data or success status | Medium | regression, api, feedback, contract |
| API-FEED-003 | Submit feedback with empty comment is rejected | Medium | regression, api, feedback, negative |
| API-FEED-004 | Submit feedback with invalid rating is rejected | Medium | regression, api, feedback, negative |
| API-FEED-005 | Submit feedback without captcha answer is rejected if required | Medium | regression, api, feedback, validation |
| API-FEED-006 | Submit feedback with script payload is safely handled | High | regression, api, feedback, security |
| API-FEED-007 | Feedback endpoint does not expose internal server errors | High | regression, api, feedback, security |

---

## 10. API Contract Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| API-CONTRACT-001 | Successful responses use expected JSON format | High | regression, api, contract |
| API-CONTRACT-002 | Error responses use consistent structure | High | regression, api, contract, negative |
| API-CONTRACT-003 | Required fields are present in product responses | High | regression, api, contract, products |
| API-CONTRACT-004 | Required fields are present in basket responses | High | regression, api, contract, basket |
| API-CONTRACT-005 | Required fields are present in order responses | High | regression, api, contract, checkout |
| API-CONTRACT-006 | Numeric fields use correct data types | Medium | regression, api, contract |
| API-CONTRACT-007 | Date fields use expected format where applicable | Medium | regression, api, contract |
| API-CONTRACT-008 | API does not return stack traces in response body | High | regression, api, contract, security |

NB: Contract tests are strong portfolio material because they show that you are not only checking status code 200.

---

## 11. Negative API Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| API-NEG-001 | Endpoint rejects unsupported HTTP method | Medium | regression, api, negative |
| API-NEG-002 | Endpoint rejects malformed JSON body | High | regression, api, negative |
| API-NEG-003 | Endpoint rejects missing required headers if required | Medium | regression, api, negative |
| API-NEG-004 | Endpoint handles very long input safely | High | regression, api, negative, security |
| API-NEG-005 | Endpoint handles special characters safely | High | regression, api, negative, security |
| API-NEG-006 | Endpoint handles null values safely | Medium | regression, api, negative |
| API-NEG-007 | Endpoint handles wrong data types safely | High | regression, api, negative |
| API-NEG-008 | Endpoint returns controlled error for unknown resource ID | Medium | regression, api, negative |
| API-NEG-009 | Endpoint does not return 500 for normal invalid input | High | regression, api, negative, reliability |

NB: Use these as reusable patterns. Do not repeat all of them on every endpoint. Apply them to the most important endpoints only.

---

## 12. Security-Focused API Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| API-SEC-001 | SQL injection payload in login is detected or produces documented vulnerability result | High | regression, api, security, sqli |
| API-SEC-002 | SQL injection payload in search is handled safely | High | regression, api, security, sqli |
| API-SEC-003 | XSS payload in search or feedback is handled safely | High | regression, api, security, xss |
| API-SEC-004 | Protected endpoint cannot be accessed without authentication | High | regression, api, security, auth |
| API-SEC-005 | Protected endpoint cannot be accessed with another user ID | High | regression, api, security, broken-access-control |
| API-SEC-006 | Basket ID tampering does not expose another user basket | High | regression, api, security, broken-access-control |
| API-SEC-007 | Address ID tampering does not expose another user address | High | regression, api, security, broken-access-control |
| API-SEC-008 | Payment ID tampering does not expose another user payment method | High | regression, api, security, broken-access-control |
| API-SEC-009 | API response does not expose password hashes or sensitive tokens | High | regression, api, security, data-exposure |
| API-SEC-010 | Sensitive endpoints use proper authorization checks | High | regression, api, security, authorization |
| API-SEC-011 | CORS headers are reviewed for unsafe configuration | Medium | regression, api, security, cors |
| API-SEC-012 | Security headers are reviewed where applicable | Medium | regression, api, security, headers |

NB: Since OWASP Juice Shop is intentionally vulnerable, some security tests may document vulnerabilities instead of expecting the application to block them. In the README, clearly mark those as expected findings.

---

## 13. End-to-End API Workflow Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| API-E2E-001 | Register user, login, add product to basket, checkout successfully | High | e2e, api, critical |
| API-E2E-002 | Login existing user, add product, update quantity, remove product | High | e2e, api, basket |
| API-E2E-003 | Login existing user, create address, create payment method, place order | High | e2e, api, checkout |
| API-E2E-004 | Attempt checkout with missing required data and verify rejection | High | e2e, api, negative, checkout |
| API-E2E-005 | User A cannot access User B basket, address, payment, or order data | High | e2e, api, security, broken-access-control |

NB: Keep the E2E API suite small. It should prove business flow coverage without duplicating every lower-level API test.

---
