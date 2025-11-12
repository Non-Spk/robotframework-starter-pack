*** Settings ***
Documentation    Shared API-specific keywords for HTTP interactions.


*** Keywords ***
Create API session
    [Documentation]
    ...    Creates or reuses a RequestsLibrary session for a given alias and base URL.
    ...    Optional headers, authentication, proxies, and timeout can be provided.
    [Arguments]    ${alias}    ${base_url}    ${headers}=${None}    ${auth}=${None}    ${verify}=${True}    ${timeout}=30    ${proxies}=${None}
    RequestsLibrary.Create Session
    ...    ${alias}
    ...    ${base_url}
    ...    headers=${headers}
    ...    auth=${auth}
    ...    verify=${verify}
    ...    timeout=${timeout}
    ...    proxies=${proxies}
    RETURN    ${alias}

Get request and verify status
    [Documentation]    Issues a GET request on the session and validates the response status code.
    [Arguments]    ${alias}    ${endpoint}    ${expected_status}=200    ${params}=${None}    ${headers}=${None}
    ${response}=    RequestsLibrary.GET On Session
    ...    ${alias}
    ...    ${endpoint}
    ...    params=${params}
    ...    headers=${headers}
    Verify response status code    ${response}    ${expected_status}
    RETURN    ${response}

Post JSON request
    [Documentation]    Sends a JSON payload via POST and verifies the response code.
    [Arguments]    ${alias}    ${endpoint}    ${payload}    ${expected_status}=200    ${headers}=${None}
    ${response}=    RequestsLibrary.POST On Session
    ...    ${alias}
    ...    ${endpoint}
    ...    json=${payload}
    ...    headers=${headers}
    Verify response status code    ${response}    ${expected_status}
    RETURN    ${response}

Put JSON request
    [Documentation]    Sends a JSON payload via PUT and verifies the response code.
    [Arguments]    ${alias}    ${endpoint}    ${payload}    ${expected_status}=200    ${headers}=${None}
    ${response}=    RequestsLibrary.PUT On Session
    ...    ${alias}
    ...    ${endpoint}
    ...    json=${payload}
    ...    headers=${headers}
    Verify response status code    ${response}    ${expected_status}
    RETURN    ${response}

Delete request
    [Documentation]    Issues a DELETE request and validates the response code.
    [Arguments]    ${alias}    ${endpoint}    ${expected_status}=200    ${headers}=${None}
    ${response}=    RequestsLibrary.DELETE On Session
    ...    ${alias}
    ...    ${endpoint}
    ...    headers=${headers}
    Verify response status code    ${response}    ${expected_status}
    RETURN    ${response}

Get response body as JSON
    [Documentation]    Returns the response body parsed as JSON.
    [Arguments]    ${response}
    ${body}=    BuiltIn.Evaluate    response.json()    response=${response}
    RETURN    ${body}

Should contain in JSON
    [Documentation]
    ...    Validates that a JSON path resolves to a value containing the expected text.
    ...    Supports dot notation with zero-based index access (e.g., items.0.name).
    [Arguments]    ${json_body}    ${json_path}    ${expected}
    ${value}=    Extract value from JSON    ${json_body}    ${json_path}
    ${value_str}=    BuiltIn.Convert To String    ${value}
    BuiltIn.Should Contain    ${value_str}    ${expected}    Expected '${json_path}' to contain '${expected}'.

Verify response status code
    [Documentation]    Ensures the HTTP response status code matches expectation.
    [Arguments]    ${response}    ${expected_status}=200
    ${status_code}=    BuiltIn.Evaluate    response.status_code    response=${response}
    BuiltIn.Should Be Equal As Integers    ${status_code}    ${expected_status}

Log API response
    [Documentation]    Logs the status and body of the HTTP response.
    [Arguments]    ${response}    ${level}=INFO
    ${status_code}=    BuiltIn.Evaluate    response.status_code    response=${response}
    ${body}=    BuiltIn.Evaluate    response.text    response=${response}
    BuiltIn.Log
    ...    Status: ${status_code}\nBody: ${body}
    ...    ${level}

Extract value from JSON
    [Documentation]
    ...    Extracts a nested value from JSON by dot-separated path.
    ...    Numeric segments are treated as list indexes.
    [Arguments]    ${json_body}    ${json_path}
    ${segments}=    String.Split String    ${json_path}    .
    ${current}=    BuiltIn.Set Variable    ${json_body}
    FOR    ${segment}    IN    @{segments}
        ${is_index}=    BuiltIn.Run Keyword And Return Status
        ...    Should Match Regexp
        ...    ${segment}
        ...    ^-?\d+$
        IF    ${is_index}
            ${index}=    BuiltIn.Convert To Integer    ${segment}
            ${current}=    Collections.Get From List    ${current}    ${index}
        ELSE
            ${current}=    Collections.Get From Dictionary    ${current}    ${segment}
        END
    END
    RETURN    ${current}
