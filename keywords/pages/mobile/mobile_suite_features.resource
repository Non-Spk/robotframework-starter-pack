*** Settings ***
Documentation    Mobile suite controller keywords.
Resource    ${CURDIR}/../../../resources/import.resource

*** Keywords ***
Setup mobile suite
    ${env_name}=    Collections.Get From Dictionary    ${mobile_sample_smoke}    env
    ${env}=    Get environment config    mobile    ${env_name}
    ${device_profile}=    Collections.Get From Dictionary    ${mobile_sample_smoke}    device_profile
    ${app_profile}=    Collections.Get From Dictionary    ${mobile_sample_smoke}    app_profile
    ${device}=    Get device profile    ${device_profile}
    ${app}=    Get app profile    ${app_profile}
    ${language_key}=    Collections.Get From Dictionary    ${mobile_sample_smoke}    language_key
    ${active_lang}=    Collections.Get From Dictionary    ${language}    ${language_key}
    ${run_flag}=    Collections.Get From Dictionary    ${mobile_sample_smoke}    run_mobile_tests
    Set Suite Variable    ${DEVICE_CAPABILITIES}    ${device}
    Set Suite Variable    ${APP_CONFIG}    ${app}
    Set Suite Variable    ${ACTIVE_LANG}    ${active_lang}
    Set Suite Variable    ${RUN_MOBILE_TESTS}    ${run_flag}

Teardown mobile suite
    Run Keyword And Ignore Error    Close all application

Verify mobile configuration
    Should Not Be Empty    ${DEVICE_CAPABILITIES}
    Should Not Be Empty    ${APP_CONFIG}
    ${greeting}=    Get localized text    ${ACTIVE_LANG}    mobile.login.title
    Should Not Be Empty    ${greeting}
    Log To Console    YAML Thai code: ${language['th']}
    Log To Console    ${greeting}

Execute demo app smoke
    Run Keyword Unless    ${RUN_MOBILE_TESTS}    Skip    Enable run_mobile_tests in data/tests.yaml to execute against a device.
    Open application with apk    ${DEVICE_CAPABILITIES}    ${APP_CONFIG}
    Tap element if visible    accessibility_id=LoginButton
    Close application
