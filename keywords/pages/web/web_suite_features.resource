*** Settings ***
Documentation    Web suite controller keywords for setup/teardown and shared actions.
Resource    ${CURDIR}/../../../resources/import.resource
Resource    ${CURDIR}/example_features.resource

*** Keywords ***
Setup web suite
    ${env_name}=    Collections.Get From Dictionary    ${web_sample_smoke}    env
    ${env}=    Get environment config    web    ${env_name}
    ${profile_name}=    Collections.Get From Dictionary    ${env}    browser_profile
    ${browser_profile}=    Get browser profile    ${profile_name}
    ${language_key}=    Collections.Get From Dictionary    ${web_sample_smoke}    language_key
    ${active_lang}=    Collections.Get From Dictionary    ${language}    ${language_key}
    Set Suite Variable    ${ENV_CONFIG}    ${env}
    Set Suite Variable    ${BROWSER_PROFILE}    ${browser_profile}
    Set Suite Variable    ${ACTIVE_LANG}    ${active_lang}

Teardown web suite
    Close all browser

Start web test
    ${browser_id}=    Open new browser
    ...    ${BROWSER_PROFILE['browser']}
    ...    ${BROWSER_PROFILE['headless']}
    ...    ${BROWSER_PROFILE['device']}
    ...    ${BROWSER_PROFILE['args']}
    ...    ${BROWSER_PROFILE['context']}
    ${page_id}=    Open new page    ${ENV_CONFIG['base_url']}
    Set Test Variable    ${BROWSER_ID}    ${browser_id}
    Set Test Variable    ${PAGE_ID}    ${page_id}

End web test
    Run Keyword And Ignore Error    Close browser    ${BROWSER_ID}

Verify example heading matches locale
    Example heading should match locale

Verify example body copy matches locale
    Example body copy should match locale

Log localized greeting
    ${greeting}=    Get localized text    ${ACTIVE_LANG}    general.greeting
    Should Not Be Empty    ${greeting}
    Log To Console    Active=${ACTIVE_LANG}, Thai code=${language['th']}
    Log To Console    ${greeting}
