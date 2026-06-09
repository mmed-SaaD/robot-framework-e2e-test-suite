# OWASP Juice Shop Performance Test Cases

## Purpose

This document defines the performance test coverage for the Robot Framework freelance QA automation portfolio project against OWASP Juice Shop.

The goal of this phase is to validate how the main backend endpoints behave under different traffic conditions after completing the UI and API test layers.

The performance suite should focus on a small number of important endpoints instead of testing every API route. This keeps the project realistic, maintainable, and suitable for a portfolio.

The performance suite should cover:

- API availability under light traffic
- Response time stability
- Error rate under concurrent users
- Behaviour under increasing load
- System limits under stress
- Basic endurance/soak stability
- Performance comparison between public and authenticated endpoints
- Performance issues affecting critical business workflows

---

## Scope Strategy

The UI suite validates user-facing workflows.

The API suite validates backend correctness, contracts, authentication, authorization, and security behaviour.

The performance suite should validate how stable and responsive the backend remains when multiple users interact with key endpoints.

Avoid performance testing every API endpoint. Focus on endpoints that are:

- Frequently used
- Business-critical
- Authentication-related
- Used in checkout flow
- Likely to be called by many users
- Useful for demonstrating realistic QA engineering skills

---


## 1. Performance Smoke Tests

| ID | Test Case | Endpoint Area | Priority | Suggested Tags |
|---|---|---|---:|---|
| PERF-SMOKE-001 | Product search endpoint responds successfully under minimal traffic | Products | High | performance, smoke, products | => Checked
| PERF-SMOKE-002 | Login endpoint responds successfully under minimal traffic | Authentication | High | performance, smoke, auth | => Checked
| PERF-SMOKE-003 | Add item to basket works under minimal authenticated traffic | Basket | High | performance, smoke, basket, auth | => Checked
| PERF-SMOKE-004 | Captcha and feedback endpoints respond successfully under minimal traffic | Feedback | Medium | performance, smoke, feedback | => Checked

---

## 2. Product Search Performance Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| PERF-PROD-001 | Product search handles expected concurrent users | High | performance, products, load | => Checked
| PERF-PROD-002 | Product search remains stable under high traffic | High | performance, products, stress | => Checked
| PERF-PROD-003 | Product search recovers after sudden traffic spike | Medium | performance, products, spike | => Checked
| PERF-PROD-004 | Product search maintains stable response time during longer run | Medium | performance, products, soak | => Checked

---

## 3. Login Performance Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| PERF-AUTH-001 | Login endpoint handles expected concurrent login attempts | High | performance, auth, load | => Checked
| PERF-AUTH-002 | Login endpoint behaviour is documented under excessive login traffic | High | performance, auth, stress | => Checked
| PERF-AUTH-003 | Login endpoint recovers after sudden spike of login attempts | Medium | performance, auth, spike | => Checked
| PERF-AUTH-004 | Login endpoint maintains stable response time during longer run | Medium | performance, auth, soak | => >Checked

---

## 4. Basket Performance Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| PERF-BASKET-001 | Basket item creation handles expected authenticated concurrent usage | High | performance, basket, load, auth | => Checked
| PERF-BASKET-002 | Basket endpoint behaviour is documented under high authenticated traffic | High | performance, basket, stress, auth | => Checked
| PERF-BASKET-003 | Basket endpoint recovers after sudden authenticated traffic spike | Medium | performance, basket, spike, auth | => Checked
| PERF-BASKET-004 | Basket endpoint maintains stable response time during longer authenticated run | Medium | performance, basket, soak, auth | => Checked

---

## 5. Feedback Performance Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| PERF-FEED-001 | Feedback submission behaviour is documented under moderate concurrent usage | Medium | performance, feedback, load | => Checked
| PERF-FEED-002 | Feedback submission behaviour is documented under high concurrent usage | Medium | performance, feedback, stress | => Checked
| PERF-FEED-003 | Feedback endpoint recovers after sudden submission traffic spike | Medium | performance, feedback, spike | => Checked
| PERF-FEED-004 | Feedback endpoint maintains stable response time during longer controlled run | Low | performance, feedback, soak | => Checked
