*** Settings ***
Documentation    Shared Browser-library keywords for web automation.


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

Capture page screenshot
    [Documentation]    Take a screenshot and save with timestamp
    [Arguments]    ${file_prefix}=screenshot
    ${timestamp}=    DateTime.Get Current Date    result_format=%Y%m%d_%H%M%S
    ${file_path}=    BuiltIn.Set Variable    ${OUTPUT DIR}/screenshot/${file_prefix}_${timestamp}.png
    Browser.Take Screenshot    ${file_path}
    BuiltIn.Log To Console    Screenshot saved to ${file_path}
    RETURN    ${file_path}

Click element and wait
    [Documentation]    Scroll and click to element and wait until the page is loaded or the element disappears
    [Arguments]    ${locator}    ${wait_until}
    Browser.Scroll To Element    ${locator}
    Browser.Click    ${locator}
    Browser.Wait For Load State    ${wait_until}

Click element right
    [Documentation]    Perform a right-click on the specified element.
    [Arguments]    ${locator}
    Browser.Scroll To Element    ${locator}
    Browser.Click With Options
    ...    ${locator}
    ...    button=right

Close browser
    [Documentation]    Close browser
    [Arguments]    ${browser}
    Browser.Close Browser    ${browser}

Close all browser
    [Documentation]    Close all browser
    Browser.Close Browser    ALL

Close current browser
    [Documentation]    Close current browser
    Browser.Close Browser    CURRENT

Double click element
    [Documentation]    Perform a double left-click on the specified element.
    [Arguments]    ${locator}
    Browser.Scroll To Element    ${locator}
    Browser.Click With Options
    ...    ${locator}
    ...    button=left
    ...    clickCount=2

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

Element should contain text
    [Documentation]    Verify element contains specific text
    [Arguments]    ${locator}    ${expected_text}
    ${actual_text}=    Browser.Get Text    ${locator}
    BuiltIn.Should Contain    ${actual_text}    ${expected_text}    msg=Element text mismatch

Get element text
    [Documentation]    Get text from element
    [Arguments]    ${locator}
    Browser.Scroll To Element    ${locator}
    ${text}=    Browser.Get Text    ${locator}
    RETURN    ${text}

Go to url
    [Documentation]    Go to url in current page
    [Arguments]    ${url}
    Browser.Go To    ${url}    wait_until=domcontentloaded

Hover and click
    [Documentation]
    ...    Move cursor to element and click
    [Arguments]    ${locator}
    Browser.Scroll To Element    ${locator}
    Browser.Hover    ${locator}
    Browser.Click    ${locator}

Input text and press enter
    [Documentation]    Scroll and input the specified text into an input field and press ENTER key.
    [Arguments]    ${locator}    ${text}
    Browser.Scroll To Element    ${locator}
    Browser.Fill Text    ${locator}    ${text}
    ${current_value}=    Browser.Get Property    ${locator}    value
    BuiltIn.Should Be Equal    ${current_value}    ${text}    msg=Text input verification failed for ${locator}
    Browser.Press Keys    ${locator}    Enter

Input text and verify
    [Documentation]    Scroll and input text into a field and verify the text value is correctly set
    [Arguments]    ${locator}    ${text}
    Browser.Scroll To Element    ${locator}
    Browser.Fill Text    ${locator}    ${text}
    ${current_value}=    Browser.Get Property    ${locator}    value
    BuiltIn.Should Be Equal    ${current_value}    ${text}    msg=Text input verification failed for ${locator}

Open new browser
    [Documentation]
    ...    Opens a new Playwright browser with optional device emulation or custom context options.
    ...    select device size in https://github.com/microsoft/playwright/blob/main/packages/playwright-core/src/server/deviceDescriptorsSource.json
    [Arguments]    ${browser}=chromium    ${on_headless}=${False}    ${device}=${None}    ${args}=${None}    ${context}=${None}
    ${browser_id}=    Browser.New Browser    ${browser}    ${on_headless}    args=${args}
    ${device_context}=    BuiltIn.Set Variable    ${None}
    IF    ${device} is not None
        ${device_context}=    Browser.Get Device    ${device}
    END
    ${combined_context}=    BuiltIn.Evaluate
    ...    {**(device_ctx or {}), **(extra_ctx or {})}
    ...    device_ctx=${device_context}
    ...    extra_ctx=${context}
    ${has_context}=    BuiltIn.Evaluate    bool(payload)    payload=${combined_context}
    IF    ${has_context}
        Browser.New Context    &{combined_context}
    ELSE
        Browser.New Context
    END
    RETURN    ${browser_id}

Open new page
    [Documentation]    Open new page in browser
    [Arguments]    ${url}    ${wait_until}=domcontentloaded
    ${page}=    Browser.New Page    ${url}    ${wait_until}
    RETURN    ${page}

Press enter key
    [Documentation]    Press ENTER key on the specified element.
    [Arguments]    ${locator}
    Browser.Press Keys    ${locator}    Enter

Scroll to element
    [Documentation]    Scroll the page until the element is in view
    [Arguments]    ${locator}
    Browser.Scroll To Element    ${locator}

Select dropdown option
    [Documentation]
    ...    Select an option from dropdown by either value or text
    ...    Example:
    ...        Select dropdown option    //select[@id="country"]    TH    by=value
    ...        Select dropdown option    //select[@id="country"]    Thailand    by=text
    [Arguments]    ${locator}    ${option}    ${by}=text
    Browser.Scroll To Element    ${locator}
    Browser.Select Options By    ${locator}    ${by}    ${option}

Switch browser
    [Documentation]    Switch browser
    [Arguments]    ${browser}
    Browser.Switch Browser    ${browser}

Switch page
    [Documentation]    Switch page in browser
    [Arguments]    ${browser}    ${page}
    Browser.Switch Page    ${page}    ALL    ${browser}

Upload file
    [Documentation]    Upload a file to input element
    [Arguments]    ${locator}    ${file_path}
    Browser.Scroll To Element    ${locator}
    Browser.Upload File By Selector    ${locator}    ${file_path}

Wait for element visible
    [Documentation]    Wait until an element is visible in DOM
    [Arguments]    ${locator}    ${timeout}=10s
    Browser.Wait For Elements State    ${locator}    visible    ${timeout}
