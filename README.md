## UI Automation Testing - Robot Framework

The first phase of this project focuses on UI automation testing for OWASP Juice Shop using Robot Framework and SeleniumLibrary.

The goal of this layer is to validate the main user-facing workflows of the application, including authentication, product browsing, basket management, checkout, address handling, payment flow, account features, feedback submission, navigation, and negative UI scenarios.

### UI Test Execution Summary

| Metric | Result |
|---|---:|
| Total UI Tests | 77 |
| Passed | 76 |
| Failed | 1 |
| Pass Rate | 98.7% |
| Framework | Robot Framework |
| UI Library | SeleniumLibrary |
| Application Under Test | OWASP Juice Shop |

### Covered UI Modules

The UI automation suite currently covers the following modules:

| Module | Coverage |
|---|---|
| Smoke Tests | Application launch, home page load, product visibility, navigation, basket icon, login page |
| Authentication | Valid login, invalid login, empty fields, malformed email, logout, session persistence |
| Registration | Valid registration, missing fields, invalid email, weak password, existing email, password mismatch |
| Product Catalogue | Product cards, names, images, prices, details page, search, pagination, items per page |
| Basket / Cart | Add product, multiple products, counter update, quantity changes, remove items, total price, empty basket behavior |
| Checkout / Order Flow | Checkout start, address selection, delivery method, payment selection, order review, order placement, confirmation |
| Address Management | Add, edit, delete, validate required fields, verify address during checkout |
| Payment Flow | Add payment method, validate card fields, invalid card number, select and delete payment method |
| User Account / Profile | Open account page, view profile, change password, invalid password change |
| Contact / Feedback | Open feedback page, submit valid/invalid feedback, rating component, success message |
| Navigation | Menu, main links, logo redirect, basket link, account link, browser back, page refresh |
| Negative UI Tests | Invalid route, protected page access while logged out, empty required forms |

### Key Testing Practices Applied

- Modular Robot Framework structure
- Reusable keywords
- Page-specific locators
- Test tagging by feature and priority
- Positive and negative test coverage
- End-to-end user workflow validation
- Dynamic UI handling for Angular Material components
- Explicit waits for stable UI execution
- Validation of business-critical flows such as login, basket, checkout, and order placement

### Current Status

The UI automation layer is functionally complete for the first phase of the framework.

Out of 77 implemented UI tests, 76 are passing successfully. The remaining failing test is kept visible for analysis and improvement, which reflects a realistic QA workflow rather than hiding unstable or application-specific behavior.

This UI layer is now ready to be extended with the second phase of the framework: API testing.


## API Automation Testing - Robot Framework

The second phase of this project focuses on API automation testing for OWASP Juice Shop using Robot Framework and RequestsLibrary.

The goal of this layer is to validate the application's REST API endpoints, business workflows, authentication mechanisms, input validation, error handling, data integrity, and documented security vulnerabilities.

### API Test Execution Summary

| Metric                             |           Result |
| ---------------------------------- | ---------------: |
| Total API Tests                    |               86 |
| Functional Tests Passed            |               66 |
| Security Vulnerabilities Validated |               20 |
| Total Coverage                     |               86 |
| Framework                          |  Robot Framework |
| API Library                        |  RequestsLibrary |
| Application Under Test             | OWASP Juice Shop |

### Covered API Modules

The API automation suite currently covers the following modules:

| Module                   | Coverage                                                                                                             |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------- |
| Authentication           | Valid login, invalid login, empty credentials, malformed credentials, token generation, authorization validation     |
| Registration             | Valid registration, duplicate account detection, missing required fields, invalid email formats, password validation |
| Products                 | Product retrieval, product details, catalogue validation, search functionality, response schema validation           |
| Basket Management        | Create basket, add product, update quantity, remove product, basket persistence, basket retrieval                    |
| Checkout Flow            | Basket validation, address selection, delivery method selection, payment method selection, order placement           |
| Address Management       | Create address, retrieve addresses, validate mandatory fields, verify address persistence                            |
| Payment Methods          | Add payment method, validate card information, retrieve payment methods, delete payment method                       |
| Feedback                 | Submit feedback, captcha validation, invalid feedback scenarios, response validation                                 |
| API Contract Validation  | Response structure verification, required fields validation, status code validation                                  |
| Negative Testing         | Invalid endpoints, unsupported HTTP methods, malformed requests, missing authorization headers                       |
| End-to-End API Workflows | Registration → Login → Basket → Checkout complete business flow                                                      |

### Security Testing Coverage

The API suite also validates multiple OWASP-related security scenarios:

| Category                   | Coverage                                                                  |
| -------------------------- | ------------------------------------------------------------------------- |
| SQL Injection              | Login endpoint testing, search endpoint testing, vulnerability validation |
| Cross-Site Scripting (XSS) | Feedback and input field payload validation                               |
| Broken Access Control      | Unauthorized resource access attempts                                     |
| Sensitive Data Exposure    | Verification of exposed data in API responses                             |
| Input Validation           | Invalid payloads, malformed requests, boundary conditions                 |
| Error Handling             | Internal error exposure checks and stack trace detection                  |

### Key Testing Practices Applied

* Modular Robot Framework architecture
* Reusable API keywords
* Session and authentication management
* Dynamic test data generation
* Positive and negative API coverage
* Contract and schema validation
* Security-focused test scenarios
* End-to-end business workflow validation
* Response content verification
* Status code and error handling validation

### Security Validation Notes

OWASP Juice Shop is intentionally vulnerable by design. Security-related tests are therefore used to validate and document known vulnerabilities rather than expecting secure behavior.

The framework distinguishes between:

* Functional API validation
* Negative API validation
* Security vulnerability validation

This approach allows the test suite to verify both expected business functionality and intentionally vulnerable application behavior.

### Current Status

The API automation layer is functionally complete and provides broad coverage across the application's core business workflows and security scenarios.

The suite includes 86 implemented API tests covering authentication, registration, products, basket operations, checkout, feedback, contract validation, negative testing, and security validation.

With both the UI and API layers implemented, the framework is ready to be extended with additional quality engineering capabilities such as database validation, performance testing, security scanning, reporting enhancements, and CI/CD integration.

## Grafana Dashboards

The following Grafana dashboards were used to visualize performance metrics collected during test execution. Metrics were exported from k6 to InfluxDB and analyzed in real time.

### Smoke Testing Dashboard

![Smoke Testing Dashboard](artifacts/figures/smoke.png)

---

### Load Testing Dashboard

![Smoke Testing Dashboard](artifacts/figures/load.png)

---

### Stress Testing Dashboard

![Smoke Testing Dashboard](artifacts/figures/stress.png)

---

### Spike Testing Dashboard

![Smoke Testing Dashboard](artifacts/figures/spike.png)

---

### Soak Testing Dashboard

![Smoke Testing Dashboard](artifacts/figures/soak.png)

---

### Metrics Visualized

* Average Response Time
* P90 Response Time
* P95 Response Time
* Request Throughput
* Requests Per Second (RPS)
* Virtual Users (VUs)
* Error Rate
* Iteration Duration
* Endpoint-Level Performance Metrics
* Test Success Rate
