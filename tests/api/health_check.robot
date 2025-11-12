*** Settings ***
Documentation    Sample API health-check suite using page-object keywords and YAML variable files.
Variables   ${CURDIR}/../../data/tests.yaml
Resource    ${CURDIR}/../../resources/import.resource
Resource    ${CURDIR}/../../keywords/pages/api/health_api_features.resource
Suite Setup    Setup health API suite
Suite Teardown    Teardown health API suite

*** Test Cases ***
Health Endpoint Is Reachable
    Health endpoint should be reachable

Localized Health Message Is Returned
    Health endpoint should return localized message
