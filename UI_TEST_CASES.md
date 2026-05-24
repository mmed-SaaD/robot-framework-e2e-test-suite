# OWASP Juice Shop UI Test Cases

## Purpose

This document defines the UI test coverage for the Robot Framework enterprise QA automation project against OWASP Juice Shop.

The goal is to cover:

- Smoke testing
- Authentication
- Registration
- Product catalogue
- Basket/cart
- Checkout
- Address management
- Payment flow
- Account/profile
- Feedback/contact
- Navigation
- Negative UI scenarios
- Security-aware UI checks
- End-to-end business workflows

---

## 1. Smoke Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| UI-SMOKE-001 | App opens successfully | High | smoke, ui |   => Checked
| UI-SMOKE-002 | Home page loads correctly | High | smoke, ui |    => Checked
| UI-SMOKE-003 | Product list is visible | High | smoke, ui, products | => Checked
| UI-SMOKE-004 | Navigation menu opens | Medium | smoke, ui, navigation | => Checked
| UI-SMOKE-005 | Basket icon is visible | High | smoke, ui, basket | => Checked
| UI-SMOKE-006 | Login page opens | High | smoke, ui, auth | => Checked

---

## 2. Authentication Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| UI-AUTH-001 | Login with valid user | High | regression, ui, auth, critical | => Checked
| UI-AUTH-002 | Login with invalid email | High | regression, ui, auth, negative | => Checked
| UI-AUTH-003 | Login with invalid password | High | regression, ui, auth, negative | => Checked
| UI-AUTH-004 | Login with empty fields | High | regression, ui, auth, negative | => Checked
| UI-AUTH-005 | Login with badly formatted email | Medium | regression, ui, auth, negative | => Checked
| UI-AUTH-006 | Logout successfully | High | regression, ui, auth | => Checked
| UI-AUTH-007 | Session remains active after refresh | Medium | regression, ui, auth, session | => Checked
| UI-AUTH-008 | User cannot access protected pages after logout | High | regression, ui, auth, security-ui | => Checked

---

## 3. Registration Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| UI-REG-001 | Open registration page | Medium | regression, ui, registration | => Checked
| UI-REG-002 | Register with valid data | High | regression, ui, registration, critical | => Checked
| UI-REG-003 | Register with missing email | High | regression, ui, registration, negative | => Checked
| UI-REG-004 | Register with invalid email format | Medium | regression, ui, registration, negative | => Checked
| UI-REG-005 | Register with missing password | High | regression, ui, registration, negative | => checked
| UI-REG-006 | Register with weak password | Medium | regression, ui, registration, negative | => Checked
| UI-REG-007 | Register with existing email | Medium | regression, ui, registration, negative | => Checked
| UI-REG-008 | Security question dropdown works | Medium | regression, ui, registration | => checked
| UI-REG-009 | Register with unmatched passwords | Medium | regression, ui, registration, negative | => Checked

NB : UI-REG-008 is included in all the other test cases !

---

## 4. Product Catalogue Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| UI-PROD-001 | Products are displayed | High | regression, ui, products | => Checked
| UI-PROD-002 | Product name is visible | High | regression, ui, products | => Checked
| UI-PROD-003 | Product image is visible | Medium | regression, ui, products | => Checked
| UI-PROD-004 | Product price is visible | High | regression, ui, products | => Checked
| UI-PROD-005 | Product card opens details | High | regression, ui, products | => Checked
| UI-PROD-006 | Search product by valid name | High | regression, ui, products, search | => Checked
| UI-PROD-007 | Search product with no results | Medium | regression, ui, products, search, negative | => Checked
| UI-PROD-008 | Clear search results | Medium | regression, ui, products, search | => Checked
| UI-PROD-009 | Product pagination works | Medium | regression, ui, products | => Checked
| UI-PROD-010 | Items per page setting works | Low | regression, ui, products | => Checked

---

## 5. Basket / Cart Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| UI-BASKET-001 | Add one product to basket | High | regression, ui, basket, critical | => Checked
| UI-BASKET-002 | Add multiple products to basket | High | regression, ui, basket | => Checked
| UI-BASKET-003 | Basket counter updates | High | regression, ui, basket | => Checked
| UI-BASKET-004 | Open basket | High | regression, ui, basket | => Checked
| UI-BASKET-005 | Product appears in basket | High | regression, ui, basket | => Checked
| UI-BASKET-006 | Increase product quantity | Medium | regression, ui, basket | => Checked
| UI-BASKET-007 | Decrease product quantity | Medium | regression, ui, basket | => Checked
| UI-BASKET-008 | Remove product from basket | High | regression, ui, basket | => Checked
| UI-BASKET-009 | Basket becomes empty after removing all products | Medium | regression, ui, basket | => Checked
| UI-BASKET-010 | Total price is calculated correctly | High | regression, ui, basket, critical | => Checked
| UI-BASKET-011 | Cannot checkout with empty basket | High | regression, ui, basket, negative | => Checked
| UI-BASKET-012 | Basket persists after page refresh | Medium | regression, ui, basket, session | => Checked

---

## 6. Checkout / Order Flow Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| UI-CHECKOUT-001 | Logged-in user can start checkout | High | regression, ui, checkout, critical | => Checked
| UI-CHECKOUT-002 | Address selection page opens | High | regression, ui, checkout, address | => Checked
| UI-CHECKOUT-003 | Add new address during checkout | High | regression, ui, checkout, address | => Checked
| UI-CHECKOUT-004 | Select existing address | High | regression, ui, checkout, address | => Checked
| UI-CHECKOUT-005 | Choose delivery method | High | regression, ui, checkout | => Checked
| UI-CHECKOUT-006 | Choose payment method | High | regression, ui, checkout, payment | => Checked
| UI-CHECKOUT-007 | Review order summary | High | regression, ui, checkout | => Checked
| UI-CHECKOUT-008 | Place order successfully | High | regression, ui, checkout, critical | => Checked
| UI-CHECKOUT-009 | Order confirmation is displayed | High | regression, ui, checkout | => Checked
| UI-CHECKOUT-010 | Basket is cleared after order | High | regression, ui, checkout, basket | => Checked
| UI-CHECKOUT-011 | Order appears in order history | Medium | regression, ui, checkout, account | => Checked

NB: UI-CHECKOUT-001 and UI-CHECKOUT-002 are included in the same test case

---

## 7. Address Management Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| UI-ADDR-001 | Open saved addresses page | Medium | regression, ui, address | => Checked
| UI-ADDR-002 | Add valid address | High | regression, ui, address | => Checked
| UI-ADDR-003 | Add address with missing required fields | High | regression, ui, address, negative | => Checked
| UI-ADDR-004 | Edit address | Medium | regression, ui, address | => Checked
| UI-ADDR-005 | Delete address | Medium | regression, ui, address | => Checked
| UI-ADDR-006 | Address appears during checkout | High | regression, ui, address, checkout | => Checked

---

## 8. Payment Flow Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| UI-PAY-001 | Open saved payment options | Medium | regression, ui, payment | => Checked
| UI-PAY-002 | Add new payment method | High | regression, ui, payment | => Checked
| UI-PAY-003 | Validate missing card fields | High | regression, ui, payment, negative | => Checked
| UI-PAY-004 | Validate invalid card number | High | regression, ui, payment, negative | => Checked
| UI-PAY-005 | Select payment during checkout | High | regression, ui, payment, checkout | => Checked
| UI-PAY-006 | Delete saved payment method | Medium | regression, ui, payment | => Checked

---

## 9. User Account / Profile Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| UI-ACC-001 | Open account page | Medium | regression, ui, account |
| UI-ACC-002 | View user profile | Medium | regression, ui, account |
| UI-ACC-003 | Change password | High | regression, ui, account, auth |
| UI-ACC-004 | Try changing password with wrong current password | High | regression, ui, account, negative |
| UI-ACC-005 | Update security question if available | Medium | regression, ui, account |
| UI-ACC-006 | View order history | Medium | regression, ui, account, checkout |
| UI-ACC-007 | View previous order details | Medium | regression, ui, account, checkout |

---

## 10. Contact / Feedback Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| UI-FEED-001 | Open contact or feedback page | Medium | regression, ui, feedback |
| UI-FEED-002 | Submit valid feedback | High | regression, ui, feedback |
| UI-FEED-003 | Submit empty feedback | Medium | regression, ui, feedback, negative |
| UI-FEED-004 | Submit feedback with invalid email | Medium | regression, ui, feedback, negative |
| UI-FEED-005 | Rating component works | Low | regression, ui, feedback |
| UI-FEED-006 | Success message appears after valid feedback | High | regression, ui, feedback |

---

## 11. Navigation Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| UI-NAV-001 | Menu opens and closes | Medium | regression, ui, navigation |
| UI-NAV-002 | All main menu links work | High | regression, ui, navigation |
| UI-NAV-003 | Logo redirects to home | Medium | regression, ui, navigation |
| UI-NAV-004 | Basket link redirects to basket | High | regression, ui, navigation, basket |
| UI-NAV-005 | Account link redirects to profile or login | High | regression, ui, navigation, account |
| UI-NAV-006 | Browser back button works correctly | Medium | regression, ui, navigation |
| UI-NAV-007 | Page refresh does not break current state | Medium | regression, ui, navigation, session |

---

## 12. Negative UI Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| UI-NEG-001 | Invalid route shows error page | Medium | regression, ui, negative |
| UI-NEG-002 | Direct access to basket while logged out | High | regression, ui, negative, auth |
| UI-NEG-003 | Direct access to checkout while logged out | High | regression, ui, negative, auth, checkout |
| UI-NEG-004 | Submit forms with empty required fields | High | regression, ui, negative |
| UI-NEG-005 | Use very long text in input fields | Medium | regression, ui, negative |
| UI-NEG-006 | Use special characters in input fields | Medium | regression, ui, negative |
| UI-NEG-007 | Use spaces only in input fields | Medium | regression, ui, negative |

---

## 13. End-to-End Business Workflows

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| UI-E2E-001 | Guest user browses products then is asked to login before checkout | High | e2e, ui, auth, checkout |
| UI-E2E-002 | Registered user logs in, adds product, checks basket, and completes order | Critical | e2e, ui, critical, checkout |
| UI-E2E-003 | User registers, logs in, adds address, adds payment method, and completes first order | Critical | e2e, ui, critical, registration, checkout |
| UI-E2E-004 | User adds product to basket, logs out, logs back in, and verifies basket state | High | e2e, ui, basket, session |
| UI-E2E-005 | User searches product, opens details, adds it to basket, and completes checkout | High | e2e, ui, products, search, checkout |
| UI-E2E-006 | User adds multiple products, removes one, verifies total, and completes order | High | e2e, ui, basket, checkout |
| UI-E2E-007 | User submits feedback after completing an order | Medium | e2e, ui, feedback, checkout |

---

