*** Settings ***
Documentation    Sample cross-language web smoke suite following a page-object pattern.
Variables   ${CURDIR}/../../data/tests.yaml
Resource    ${CURDIR}/../../resources/import.resource
Resource    ${CURDIR}/../../keywords/pages/web/web_suite_features.resource
Suite Setup    Setup web suite
Suite Teardown    Teardown web suite
Test Setup    Start web test
Test Teardown    End web test

*** Test Cases ***
Example Domain Title Is Correct (EN only)
    Skip If    '${ACTIVE_LANG}' != 'en'    Example.com sample is available only in English.
    Verify example heading matches locale

Localized Greeting Strings Are Accessible
    Log localized greeting

Body Copy Is Localized
    Verify example body copy matches locale
