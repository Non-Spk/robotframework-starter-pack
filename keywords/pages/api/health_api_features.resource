*** Settings ***
Documentation    Page-object style keywords for the API health-check suite.
Resource    ${CURDIR}/../../../resources/import.resource

*** Keywords ***
Setup health API suite
    ${env_name}=    Collections.Get From Dictionary    ${api_health_check}    env
    ${config}=    Get environment config    api    ${env_name}
    ${session_alias}=    Collections.Get From Dictionary    ${api_health_check}    session_alias
    ${language_key}=    Collections.Get From Dictionary    ${api_health_check}    language_key
    ${active_lang}=    Collections.Get From Dictionary    ${language}    ${language_key}
    Set Suite Variable    ${SESSION_ALIAS}    ${session_alias}
    Set Suite Variable    ${API_CONFIG}    ${config}
    Set Suite Variable    ${ACTIVE_LANG}    ${active_lang}
    Create API session
    ...    ${session_alias}
    ...    ${config['base_url']}
    ...    timeout=${config['timeout']}
    ...    verify=${config['verify']}

Teardown health API suite
    RequestsLibrary.Delete All Sessions

Health endpoint should be reachable
    ${response}=    Get request and verify status    ${SESSION_ALIAS}    /get    200
    Log API response    ${response}
    ${body}=    Get response body as JSON    ${response}
    Should contain in JSON    ${body}    url    httpbin.org/get

Health endpoint should return localized message
    ${message}=    Get localized text    ${ACTIVE_LANG}    api.health.success
    Should Not Be Empty    ${message}
    Log To Console    ${message}
    Log To Console    YAML Thai code: ${language['th']}
