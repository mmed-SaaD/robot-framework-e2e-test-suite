*** Settings ***
Library    Process
Resource    ../../variables/performance/performance_variables.resource
Variables    ../../../core/utils/env_loader.py

*** Keywords ***
Run Performance Test
    [Arguments]    ${script_name}
    ${result}=    Run Process
    ...    ${k6}
    ...    run
    ...    ${performance_scripts_dir}/${script_name}
    ...    --out
    ...    influxdb\=http://localhost:8086/k6
    ...    env:BASE_URL=${BASE_URL}
    ...    env:EMAIL=${VALID_EMAIL}
    ...    env:PASSWORD=${VALID_PASSWORD}
    ...    stdout=PIPE
    ...    stderr=PIPE

    Log    ${result.stdout}
    Log    ${result.stderr}

    Should Be Equal As Integers    ${result.rc}    0        msg=Performance test failed while running ${script_name}.${\n}${\n}STDERR:${\n}${result.stderr}${\n}${\n}STDOUT:${\n}${result.stdout}