*** Settings ***
Library    AppiumLibrary
Library    Browser
Library    Collections
Library    DatabaseLibrary
Library    DateTime
Library    OperatingSystem
Library    Process
Library    RequestsLibrary
Library    SeleniumLibrary
Library    String

# CUSTOM LIBRARIES
Library    ${CURDIR}/library/string_utils.py    WITH NAME    StringUtils

# REUSABLE KEYWORDS
Resource    ${CURDIR}/../keywords/common/common.resource
Resource    ${CURDIR}/../keywords/common/common_api.resource
Resource    ${CURDIR}/../keywords/common/common_app.resource
Resource    ${CURDIR}/../keywords/common/common_database.resource
Resource    ${CURDIR}/../keywords/common/common_web_browser.resource
Resource    ${CURDIR}/../keywords/common/common_web_selenium.resource

