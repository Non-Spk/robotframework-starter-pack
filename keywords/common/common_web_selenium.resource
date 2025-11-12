*** Settings ***
Documentation    Setting impot path
Resource    ${CURDIR}/../../resources/import.resource


*** Keywords ***
Capture page screenshot
    [Documentation]    Take a screenshot and save with timestamp base on SeleniumLibrary
    [Arguments]    ${file_prefix}=screenshot
    ${timestamp}=    DateTime.Get Current Date    result_format=%Y%m%d_%H%M%S
    ${file_path}=    BuiltIn.Set Variable    ${OUTPUT DIR}/screenshot/${file_prefix}_${timestamp}.png
    SeleniumLibrary.Capture Page Screenshot    filename=${file_path}
    BuiltIn.Log To Console    Screenshot saved to ${file_path}
    RETURN    ${file_path}

Click when element is ready
    [Documentation]    Wait until the element is ready and click it base on SeleniumLibrary
    [Arguments]    ${locator}    ${timeout}=5s
    TRY
        Wait for element is ready    locator=${locator}    timeout=${timeout}
        SeleniumLibrary.Click Element    ${locator}
    EXCEPT
        BuiltIn.Log    Click Element '${locator}' was unsuccessful    INFO
    END

Close all browser
    [Documentation]    Close all browsers based on SeleniumLibrary
    SeleniumLibrary.Close All Browsers

Close current browser
    [Documentation]    Close current browser based on SeleniumLibrary
    SeleniumLibrary.Close Browser

Double click element
    [Documentation]    Perform a double left-click on the element base on SeleniumLibrary
    [Arguments]    ${locator}    ${timeout}=5s
    TRY
        Wait for element is ready    locator=${locator}    timeout=${timeout}
        SeleniumLibrary.Double Click Element    ${locator}
    EXCEPT
        BuiltIn.Log    Double Click Element '${locator}' was unsuccessful    INFO
    END

Element should contain text
    [Documentation]    Verify element contains specific text based on SeleniumLibrary
    [Arguments]    ${locator}    ${expected_text}    ${timeout}=5s
    Wait for element is ready    locator=${locator}    timeout=${timeout}
    SeleniumLibrary.Element Should Contain    ${locator}    ${expected_text}    message=Element text mismatch

Get element text
    [Documentation]    Get text from element based on SeleniumLibrary
    [Arguments]    ${locator}    ${timeout}=5s
    Wait for element is ready    locator=${locator}    timeout=${timeout}
    ${text}=    SeleniumLibrary.Get Text    ${locator}
    RETURN    ${text}

Go to url
    [Documentation]    Go to URL in current page based on SeleniumLibrary
    [Arguments]    ${url}
    SeleniumLibrary.Go To    ${url}

Input text and press enter
    [Documentation]    Scroll, input text into an input field, and press ENTER based on SeleniumLibrary
    [Arguments]    ${locator}    ${text}    ${timeout}=5s
    Wait for element is ready    locator=${locator}    timeout=${timeout}
    SeleniumLibrary.Input Text    ${locator}    ${text}
    ${current_value}=    SeleniumLibrary.Get Value    ${locator}
    BuiltIn.Should Be Equal    ${current_value}    ${text}    msg=Text input verification failed for ${locator}
    SeleniumLibrary.Press Keys    ${locator}    \\13

Input text and verify
    [Documentation]    Scroll and input text into a field and verify value based on SeleniumLibrary
    [Arguments]    ${locator}    ${text}    ${timeout}=5s
    Wait for element is ready    locator=${locator}    timeout=${timeout}
    SeleniumLibrary.Input Text    ${locator}    ${text}
    ${current_value}=    SeleniumLibrary.Get Value    ${locator}
    BuiltIn.Should Be Equal    ${current_value}    ${text}    msg=Text input verification failed for ${locator}

Open web browser
    [Documentation]    Open a new browser window based on SeleniumLibrary
    [Arguments]    ${url}    ${browser}=chrome    ${headless}=${False}
    ${browser}=    SeleniumLibrary.Open Browser    ${url}    ${browser}    headless=${headless}
    RETURN    ${browser}

Press enter key
    [Documentation]    Press ENTER key on the specified element based on SeleniumLibrary
    [Arguments]    ${locator}
    SeleniumLibrary.Press Keys    ${locator}    \\13

Scroll to element
    [Documentation]    Scroll page until element is in view based on SeleniumLibrary
    [Arguments]    ${locator}
    SeleniumLibrary.Scroll Element Into View    ${locator}

Select dropdown option
    [Documentation]    Select an option from dropdown by value or text based on SeleniumLibrary
    [Arguments]    ${locator}    ${option}    ${by}=text    ${timeout}=5s
    Wait for element is ready    locator=${locator}    timeout=${timeout}
    IF    '${by}' == 'value'
        SeleniumLibrary.Select From List By Value    ${locator}    ${option}
    ELSE
        SeleniumLibrary.Select From List By Label    ${locator}    ${option}
    END

Switch browser
    [Documentation]    Switch between opened browsers based on SeleniumLibrary
    [Arguments]    ${index}=0
    SeleniumLibrary.Switch Window    ${index}

Upload file
    [Documentation]    Upload a file to input element based on SeleniumLibrary
    [Arguments]    ${locator}    ${file_path}    ${timeout}=5s
    Wait for element is ready    locator=${locator}    timeout=${timeout}
    SeleniumLibrary.Choose File    ${locator}    ${file_path}

Wait for element is ready
    [Documentation]    Wait until element is present, visible, and enabled with retries based on SeleniumLibrary
    [Arguments]    ${locator}    ${timeout}=2s    ${retry}=5
    FOR    ${time}    IN RANGE    0    ${retry}
        TRY
            SeleniumLibrary.Wait Until Page Contains Element    ${locator}    ${timeout}
            SeleniumLibrary.Scroll Element Into View    ${locator}
            SeleniumLibrary.Wait Until Element Is Visible    ${locator}    ${timeout}
            SeleniumLibrary.Wait Until Element Is Enabled    ${locator}    ${timeout}
            BREAK
        EXCEPT
            BuiltIn.Log    Retry ${time + 1}/${retry}: Element '${locator}' not ready yet.    INFO
        END
    END
