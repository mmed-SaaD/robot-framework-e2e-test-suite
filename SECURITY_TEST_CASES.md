# Offensive Security Testing - Robot Framework

## Overview

The security testing layer focuses on offensive security practices by simulating real-world attacks against OWASP Juice Shop.

Unlike the API testing layer, which validates endpoint behavior and API security requirements, this layer reproduces attacker techniques to discover vulnerabilities related to client-side attacks, access control weaknesses, insecure configurations, and unsafe application behavior.

The objective is to treat security vulnerabilities as automated regression tests that can be continuously executed throughout the development lifecycle.

---

# 1. OWASP ZAP Automated Security Scanning

This module integrates OWASP ZAP automated scans into the Robot Framework pipeline to identify common web application vulnerabilities.

## Covered Security Scenarios

| ID          | Security Test                                                 |
| ----------- | ------------------------------------------------------------- |
| SEC-ZAP-001 | Perform automated spidering to discover application endpoints | => Checked
| SEC-ZAP-002 | Execute passive security analysis                             | => Checked
| SEC-ZAP-003 | Execute active vulnerability scanning                         | => Checked
| SEC-ZAP-004 | Generate HTML security reports                                | => Checked
| SEC-ZAP-005 | Fail the pipeline when critical vulnerabilities are detected  |

---

# 2. Cross-Site Scripting (XSS) Attack Simulation

This module uses browser-based attacks to verify whether malicious JavaScript can be executed within the application.

## Covered Security Scenarios

| ID          | Security Test                                                     |
| ----------- | ----------------------------------------------------------------- |
| SEC-XSS-001 | Reflected XSS payloads are not executed in user input fields      | => Checked
| SEC-XSS-002 | Stored XSS payloads are safely handled after persistence          | => Checked
| SEC-XSS-003 | JavaScript execution through malicious HTML attributes is blocked | => Checked
| SEC-XSS-004 | Browser alerts cannot be triggered by malicious scripts           | => Checked

NB : SEC-XSS-003 and SEC-XSS-004 are both included in test cases SEC-XSS-001 and SEC-XSS-002


# 3. Broken Access Control Attack Simulation

This module reproduces attacks where an authenticated user attempts to access resources belonging to another user.

## Covered Security Scenarios

| ID          | Security Test                                                          |
| ----------- | ---------------------------------------------------------------------- |
| SEC-BAC-001 | A user cannot access another user's private data                       | => Checked
| SEC-BAC-002 | A rogue user Cannot Access Another User's Resources With Tampered Token| => Checked
| SEC-BAC-003 | A non-administrator cannot access administrative functionality         | => Checked
| SEC-BAC-004 | Direct object reference manipulation does not expose unauthorized data | => Checked

---

# 4. Path Traversal Attack Simulation

This module validates the application's resistance against directory traversal attacks attempting to access unauthorized files.

## Covered Security Scenarios

| ID           | Security Test                                 |
| ------------ | --------------------------------------------- |
| SEC-PATH-001 | Relative path traversal sequences are blocked | => Checked
| SEC-PATH-002 | Sensitive system files cannot be accessed     | => Checked
| SEC-PATH-003 | Encoded traversal payloads are rejected       | => Checked

# 5. Malicious File Upload Testing

This module verifies that file upload mechanisms correctly validate uploaded content and prevent dangerous file execution.

## Covered Security Scenarios

| ID             | Security Test                                       |
| -------------- | --------------------------------------------------- |
| SEC-UPLOAD-001 | Executable files are rejected                       | => Checked
| SEC-UPLOAD-002 | Malicious file extensions are blocked               | => Checked
=