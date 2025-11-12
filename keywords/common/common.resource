*** Settings ***
Documentation    General-purpose reusable keywords shared across platforms.


*** Keywords ***
Build encoded url
    [Documentation]
    ...    Build encoded url from base url, username and password
    ...    Example:
    ...            base url = http://localhost:8080
    ...            username = admin
    ...            password = 1234@5678
    ...    Result_url_before_use_this_keyword:
    ...            http://username:password_with_encoded@localhost:8080
    ...    Result_url_after_use_this_keyword:
    ...            http://admin:1234%405678@localhost:8080
    [Arguments]    ${base_url}    ${username}    ${password}
    ${scheme}=    BuiltIn.Evaluate    'https' if "${base_url}".startswith('https://') else 'http'
    ${base_url_no_scheme}=    BuiltIn.Evaluate    "${base_url}".replace(f"{${scheme}}://", '')
    ${encoded_username}=    BuiltIn.Evaluate    urllib.parse.quote("${username}", safe='')    modules=urllib.parse
    ${encoded_password}=    BuiltIn.Evaluate    urllib.parse.quote("${password}", safe='')    modules=urllib.parse
    ${result}=    BuiltIn.Evaluate    '${scheme}://${encoded_username}:${encoded_password}@${base_url_no_scheme}'
    RETURN    ${result}

Convert ce to be year
    [Documentation]
    ...    Converts a CE (AD) year to Buddhist Era (BE).
    ...    Example: input 2025 -> output 2568
    [Arguments]    ${CE_year}
    ${BE_year}=    BuiltIn.Evaluate    int(${CE_year}) + 543
    RETURN    ${BE_year}

Download file from url link and run curl process
    [Documentation]
    ...    You must first get the actual URL from the link and store it in a variable (e.g., link_download)
    ...    before passing it to your download keyword. You should not pass the XPath directly to the download keyword;
    ...    only the real URL should be passed.
    ...    cwd = for fix dir download path.
    ...    -s   --silent = Do not show progress meter or messages during download.
    ...    -S   --show-error = When used with -s, still shows error messages if they occur.
    ...    -L   --location = Follow HTTP redirects automatically.
    ...    -O   --remote-name = Save the file using the original filename from the URL.
    ...    -J   --remote-header-name When used with -O, use the filename from the server's,
    ...    Content-Disposition header if available.
    [Arguments]    ${link_download}    ${download_dir}
    OperatingSystem.Create Directory    ${download_dir}
    ${result}=    Process.Run Process    curl    -sS    -L    -O    -J    ${link_download}    cwd=${download_dir}
    RETURN    ${result.stdout}

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

Get type of arguments
    [Documentation]    Returns the Python type name of the given argument.
    [Arguments]    ${argus}
    ${type}=    StringUtils.Get Type Name    value=${argus}
    RETURN    ${type}

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

Parse date
    [Documentation]
    ...    Converts a string date into a datetime object.
    ...    Can be extended to support multiple date formats and Thai Buddhist year.
    [Arguments]    ${value}
    ${value}=    BuiltIn.Set Variable    ${value.strip()}
    ${dt}=    StringUtils.Parse date    value=${value}
    RETURN    ${dt}

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
