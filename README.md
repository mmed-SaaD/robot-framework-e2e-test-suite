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