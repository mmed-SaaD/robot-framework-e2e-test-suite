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

## Selected Endpoints For Performance Testing

| Endpoint Area | Endpoint Example | Reason For Selection |
|---|---|---|
| Product Catalogue | `GET /rest/products/search?q=` | Public, frequently used, core browsing feature |
| Authentication | `POST /rest/user/login` | Critical endpoint, used before protected actions |
| Basket / Cart | `POST /api/BasketItems` | Authenticated, business-critical, write operation |
| Feedback / Captcha | `GET /rest/captcha` + `POST /api/Feedbacks` | Public/user interaction endpoint, useful for mixed read/write testing |

NB: These four endpoint areas are enough for the first performance phase. They show public read traffic, authentication traffic, authenticated write traffic, and user-generated content traffic.

---

## Performance Test Types

| Test Type | Purpose | Expected Behaviour |
|---|---|---|
| Smoke Test | Verify the script, endpoint, and environment work correctly with very low traffic | All requests succeed with stable response times |
| Load Test | Verify the endpoint under expected normal concurrent usage | Response time remains acceptable and error rate stays low |
| Stress Test | Push the endpoint beyond normal usage to identify breaking point | System may slow down, but should fail in a controlled way |
| Spike Test | Apply sudden traffic increase | System should recover after the spike |
| Soak Test | Run moderate traffic for a longer duration | No major degradation over time |

---

## Suggested Performance Thresholds

| Metric | Suggested Threshold |
|---|---:|
| HTTP request failed rate | `< 1%` for smoke/load tests |
| Average response time | `< 500 ms` for normal load |
| 95th percentile response time | `< 1000 ms` for normal load |
| 99th percentile response time | `< 2000 ms` for normal load |
| Stress test error rate | Documented, not necessarily failed |
| Spike recovery | Response times return to normal after traffic drops |

NB: These thresholds can be adjusted depending on the local machine, Docker resources, and Juice Shop environment stability.

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
| PERF-PROD-002 | Product search remains stable under high traffic | High | performance, products, stress |
| PERF-PROD-003 | Product search recovers after sudden traffic spike | Medium | performance, products, spike |
| PERF-PROD-004 | Product search maintains stable response time during longer run | Medium | performance, products, soak |

Recommended endpoint:

```http
GET /rest/products/search?q=apple
```

Why this endpoint is important:

- It is public.
- It is frequently used by customers.
- It represents product browsing/search behaviour.
- It is safe to run repeatedly because it does not create data.

---

## 3. Login Performance Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| PERF-AUTH-001 | Login endpoint handles expected concurrent login attempts | High | performance, auth, load | => Checked
| PERF-AUTH-002 | Login endpoint behaviour is documented under excessive login traffic | High | performance, auth, stress |
| PERF-AUTH-003 | Login endpoint recovers after sudden spike of login attempts | Medium | performance, auth, spike |

Recommended endpoint:

```http
POST /rest/user/login
```

Why this endpoint is important:

- It is business-critical.
- It is required before protected user actions.
- It verifies backend response time for authentication.
- It helps identify slowdowns in token generation/session handling.

NB: Use valid test credentials only. Do not use destructive or brute-force-style scenarios. This is performance testing, not an attack simulation.

---

## 4. Basket Performance Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| PERF-BASKET-001 | Basket item creation handles expected authenticated concurrent usage | High | performance, basket, load, auth |
| PERF-BASKET-002 | Basket endpoint behaviour is documented under high authenticated traffic | High | performance, basket, stress, auth |
| PERF-BASKET-003 | Basket endpoint response time remains acceptable for write operations | High | performance, basket, response-time |

Recommended endpoint:

```http
POST /api/BasketItems
```

Why this endpoint is important:

- It represents a real shopping action.
- It is authenticated.
- It is a write operation, so it is more realistic than only testing GET endpoints.
- It is part of the checkout journey.

NB: Prepare a test user and basket before running the test. Use setup logic to create or retrieve the basket ID.

---

## 5. Feedback Performance Tests

| ID | Test Case | Priority | Suggested Tags |
|---|---|---:|---|
| PERF-FEED-001 | Captcha endpoint handles expected concurrent users | Medium | performance, feedback, captcha, load | => Checked
| PERF-FEED-002 | Feedback submission works under controlled low traffic | Medium | performance, feedback, smoke |
| PERF-FEED-003 | Feedback submission behaviour is documented under moderate concurrent usage | Medium | performance, feedback, load |

Recommended endpoints:

```http
GET /rest/captcha
POST /api/Feedbacks
```

Why this endpoint is important:

- It combines a read operation and a write operation.
- It simulates a realistic user interaction.
- It validates performance of a public form submission flow.
- It is useful for checking whether user-generated input slows down the backend.

NB: For load testing feedback submission, avoid creating excessive unnecessary data. Keep the virtual user count moderate.

Suggested flow:

```text
1. Search products
2. Login with valid user
3. Extract authentication token and basket ID
4. Add product to basket
5. Validate successful response
```

Why this scenario is important:

- It is closer to real user behaviour.
- It connects public and authenticated APIs.
- It demonstrates that the framework can handle dynamic data.
- It gives the portfolio a stronger business-oriented performance test.

---

## 7. Suggested Execution Profiles

| Profile | Virtual Users | Duration | Purpose |
|---|---:|---:|---|
| Smoke | 1 user | 30 seconds | Verify script and endpoint health |
| Load | 10-20 users | 3-5 minutes | Simulate expected local usage |
| Stress | 50-100 users | 2-3 minutes | Identify degradation point |
| Spike | 5 users then 80 users then 5 users | 2-3 minutes | Validate recovery after sudden traffic |
| Soak | 10 users | 10-15 minutes | Check short-term stability |

NB: Since OWASP Juice Shop usually runs locally in Docker, these values should remain reasonable. The goal is not to destroy the local environment, but to show controlled performance engineering.

---

## 8. Performance Metrics To Collect

| Metric | Meaning |
|---|---|
| `http_req_duration` | Total request duration |
| `http_req_failed` | Failed request rate |
| `http_reqs` | Total number of requests |
| `vus` | Active virtual users |
| `iterations` | Completed test iterations |
| `checks` | Passed/failed validation checks |
| `p95` | 95th percentile response time |
| `p99` | 99th percentile response time |

---

## 9. Performance Test Execution Summary

| Metric | Result |
|---|---:|
| Total Performance Test Areas | 4 |
| Total Performance Test Cases | 22 |
| Covered Endpoint Areas | Products, Authentication, Basket, Feedback |
| Test Types Covered | Smoke, Load, Stress, Spike, Soak |
| Tool | k6 |
| Application Under Test | OWASP Juice Shop |

---

## 10. Recommended Folder Structure

```text
performance/
├── scripts/
│   ├── product_search_perf.js
│   ├── login_perf.js
│   ├── basket_perf.js
│   ├── feedback_perf.js
│   └── e2e_api_journey_perf.js
├── data/
│   └── users.json
├── results/
│   ├── smoke/
│   ├── load/
│   ├── stress/
│   ├── spike/
│   └── soak/
└── README.md
```

---

## 11. Recommended k6 Commands

```bash
# Smoke test
k6 run performance/scripts/product_search_perf.js

# Load test
k6 run -e TEST_TYPE=load performance/scripts/product_search_perf.js

# Stress test
k6 run -e TEST_TYPE=stress performance/scripts/product_search_perf.js

# Spike test
k6 run -e TEST_TYPE=spike performance/scripts/product_search_perf.js

# Soak test
k6 run -e TEST_TYPE=soak performance/scripts/product_search_perf.js
```

---

## 12. Notes

The performance test suite is intentionally smaller than the UI and API suites.

This is a better strategy because performance testing should focus on the most valuable and risky flows instead of covering every endpoint.

A portfolio project does not need hundreds of performance tests. A clean set of focused tests with good metrics, thresholds, reports, and explanations is stronger than a large but repetitive performance suite.

