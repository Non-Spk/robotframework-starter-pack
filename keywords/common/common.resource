*** Settings ***
Documentation    General-purpose reusable keywords shared across platforms.


*** Keywords ***
Convert ce to be year
    [Documentation]
    ...    Converts a CE (AD) year to Buddhist Era (BE).
    ...    Example: input 2025 -> output 2568
    [Arguments]    ${CE_year}
    ${BE_year}=    BuiltIn.Evaluate    int(${CE_year}) + 543
    RETURN    ${BE_year}

Generate random string
    [Documentation]    Generates a random string of given length using letters and digits.
    [Arguments]    ${length}=8
    ${chars}=    BuiltIn.Evaluate    __import__('string').ascii_letters + __import__('string').digits
    ${random_string}=    BuiltIn.Evaluate    ''.join(__import__('random').choice('${chars}') for _ in range(${length}))
    RETURN    ${random_string}

Get current date
    [Documentation]
    ...    Returns the current date in local timezone
    ...    Example: output 2025-01-01
    ${cur_date}=    DateTime.Get Current Date    result_format=%Y-%m-%d
    RETURN    ${cur_date}

Get current time
    [Documentation]
    ...    Returns the current time in local timezone
    ...    Example: output 08:00
    ${cur_time}=    DateTime.Get Current Date    result_format=%H:%M
    RETURN    ${cur_time}

Get os platform
    [Documentation]
    ...    Get os platform either darwin (Mac) or window
    ${platform}=    BuiltIn.Evaluate    platform.system()    platform
    ${system}=    String.Convert to lower case    ${platform}
    RETURN    ${system}

Log to console
    [Documentation]
    ...    Logs a message to the console or log.html with a specified level.
    ...    Available levels:
    ...    - TRACE: not shown in terminal, shown in debug console and log.html
    ...    - DEBUG: not shown in terminal, shown in debug console and log.html
    ...    - INFO: shown in terminal, debug console, log.html, and report.html
    ...    - WARN: shown in terminal, debug console, log.html, and report.html
    ...    - ERROR: shown in terminal, debug console, log.html, and report.html
    [Arguments]    ${message}    ${level}=INFO
    BuiltIn.Log    ${message}    ${level}

Should be equal ignore case
    [Documentation]    Verifies that two strings are equal ignoring case.
    [Arguments]    ${expected}    ${actual}    ${msg}=None
    ${expected_lower}=    BuiltIn.Evaluate    str(${expected}).lower()
    ${actual_lower}=      BuiltIn.Evaluate    str(${actual}).lower()
    BuiltIn.Should Be Equal    ${expected_lower}    ${actual_lower}    ${msg}

Should contain text
    [Documentation]    Verifies that the given text contains the expected substring.
    [Arguments]    ${full_text}    ${substring}    ${msg}=None
    BuiltIn.Should Contain    ${full_text}    ${substring}    ${msg}

Wait for seconds
    [Documentation]    Waits for given number of seconds.
    [Arguments]    ${seconds}=1
    BuiltIn.Sleep    ${seconds}s
