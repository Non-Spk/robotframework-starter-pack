*** Settings ***
Documentation    Sample mobile smoke showing YAML-driven variables and page-object keywords.
Variables   ${CURDIR}/../../data/tests.yaml
Resource    ${CURDIR}/../../resources/import.resource
Resource    ${CURDIR}/../../keywords/pages/mobile/mobile_suite_features.resource
Suite Setup    Setup mobile suite
Suite Teardown    Teardown mobile suite

*** Test Cases ***
Verify Mobile Configurations Are Resolved
    Verify mobile configuration

Open Demo App Smoke (Requires Device)
    Execute demo app smoke
