*** Settings ***
Resource    ../../resources/keywords/performance/performance_keywords.resource

*** Test Cases ***
Run Smoke Performance Test
    [Tags]    performance    smoke
    Run Performance Test    smoke_perf.js

Run Load Performance Test
    [Tags]    performance    load
    Run Performance Test    load_perf.js

Run Soak Performance Test
    [Tags]    performance    soak
    Run Performance Test    soak_perf.js

Run Spike Performance Test
    [Tags]    performance    spike
    Run Performance Test    spike_perf.js

Run Stress Performance Test
    [Tags]    performance    stress
    Run Performance Test    stress_perf.js