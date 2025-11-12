*** Settings ***
Library    AppiumLibrary
Library    Browser
Library    Collections
Library    DatabaseLibrary
Library    DateTime
Library    OperatingSystem
Library    Process
Library    RequestsLibrary
Library    String


# common keywords and helpers
Resource    ${CURDIR}/../keywords/pages/support/runtime_features.resource
Resource    ${CURDIR}/../keywords/common/common.resource
Resource    ${CURDIR}/../keywords/common/common_api.resource
Resource    ${CURDIR}/../keywords/common/common_app.resource
Resource    ${CURDIR}/../keywords/common/common_database.resource
Resource    ${CURDIR}/../keywords/common/common_web.resource
