*** Settings ***
Documentation    Example web page object that imports the global resource bundle.
Resource    ${CURDIR}/../../../resources/import.resource

*** Variables ***
${EXAMPLE_HEADING}    //h1
${EXAMPLE_BODY}       //div[@id='content']/p

*** Keywords ***
Example heading should match locale
    [Documentation]
    ...    Verifies the H1 text using localized copy resolved by ACTIVE_LANG.
    ${expected}=    Get localized text    ${ACTIVE_LANG}    web.sample_page.heading
    Wait for element visible    ${EXAMPLE_HEADING}
    ${actual}=    Get element text    ${EXAMPLE_HEADING}
    Should Be Equal    ${actual}    ${expected}

Example body copy should match locale
    ${expected}=    Get localized text    ${ACTIVE_LANG}    web.sample_page.body_copy
    ${actual}=    Get element text    ${EXAMPLE_BODY}
    Should Be Equal    ${actual}    ${expected}
