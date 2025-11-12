*** Settings ***
Documentation    Setting impot path
Resource    ${CURDIR}/../../resources/import.resource


*** Keywords ***
Open application with apk
    [Documentation]
    ...    Opens a mobile application on a specified device using Appium.
    ...    This keyword initializes a connection to the mobile device/emulator
    ...    and launches the application (APK) with the desired capabilities.
    ...    Arguments:
    ...        ${device} : Dictionary containing device information.
    ...            Keys:
    ...                - remote_url      : Appium server URL
    ...                - automation_name : Automation engine (e.g., UiAutomator2, XCUITest)
    ...                - device_name     : Device name or emulator name
    ...                - platform_name   : Platform (Android / iOS)
    ...                - platform_version: OS version of the device
    ...        ${app} : Dictionary containing application information.
    ...            Keys:
    ...                - apk_path   : Path to the APK or app file
    ...                - permission : Boolean to auto-grant permissions
    ...                - reset      : Boolean to perform full reset before launch
    ...    Example:
    ...        ${device}=    Create Dictionary
    ...        ...    remote_url=http://localhost:4723/wd/hub
    ...        ...    automation_name=UiAutomator2
    ...        ...    device_name=Pixel_5
    ...        ...    platform_name=Android
    ...        ...    platform_version=13
    ...        ${app}=    Create Dictionary
    ...        ...    apk_path=${CURDIR}/apps/my_app.apk
    ...        ...    permission=True
    ...        ...    reset=False
    ...        Open application    ${device}    ${app}
    [Arguments]    ${device}    ${app}
    AppiumLibrary.Open Application
    ...    remote_url=${device['remote_url']}
    ...    automationName=${device['automation_name']}
    ...    deviceName=${device['device_name']}
    ...    platformName=${device['platform_name']}
    ...    platformVersion=${device['platform_version']}
    ...    app=${app['apk_path']}
    ...    autoGrantPermissions=${app['permission']}
    ...    fullReset=${app['reset']}

Close application
    [Documentation]    Close current application
    AppiumLibrary.Close Application

Close all application
    [Documentation]    Close all application
    AppiumLibrary.Close All Applications

Tap element if visible
    [Documentation]
    ...    Tap on a mobile element only if it is visible on the screen.
    ...    Useful when the element may or may not appear during the test flow.
    [Arguments]    ${locator}    ${timeout}=5s
    TRY
        AppiumLibrary.Wait Until Page Contains Element    ${locator}    ${timeout}
        AppiumLibrary.Wait Until Element Is Visible    ${locator}    ${timeout}
        TRY
            AppiumLibrary.Tap    ${locator}
            BuiltIn.Log    Successfully tapped element '${locator}'
        EXCEPT
            BuiltIn.Log    Initial tap failed, falling back to click on element '${locator}'    level=WARN
            AppiumLibrary.Click Element    ${locator}
        END
    EXCEPT
        BuiltIn.Log    Element '${locator}' is not visible, tap skipped    level=ERROR
    END

Input text on field
    [Documentation]
    ...    Input specified text into a mobile element (input field) and verify the input.
    ...    Waits until the element is present and visible before typing.
    [Arguments]    ${locator}    ${text}    ${timeout}=5s
    TRY
        AppiumLibrary.Wait Until Page Contains Element    ${locator}    ${timeout}
        AppiumLibrary.Wait Until Element Is Visible    ${locator}    ${timeout}
        TRY
            AppiumLibrary.Clear Text    ${locator}
            AppiumLibrary.Input Text    ${locator}    ${text}
            ${value}=    AppiumLibrary.Get Text    ${locator}
            BuiltIn.Should Be Equal    ${value}    ${text}    msg=Text input verification failed on element '${locator}'
            BuiltIn.Log    Input text '${text}' into element '${locator}' successfully and verified
        EXCEPT
            BuiltIn.Log    Failed to input or verify text '${text}' on element '${locator}'    level=WARN
        END
    EXCEPT
        BuiltIn.Log    Element '${locator}' is not visible, input skipped    level=ERROR
    END

Swipe in direction
    [Documentation]
    ...    Performs a swipe gesture within a specified container element in a given direction.
    ...    The swipe can be 'up', 'down', 'left', or 'right'.
    ...    Start and end positions are calculated based on container size, location,
    ...    and percentage values provided in the swipe_config.
    ...    [Arguments]
    ...    ${container}         The locator of the container element to perform the swipe in.
    ...    ${swipe_config}       A dictionary containing swipe parameters:
    ...                          - direction: 'up', 'down', 'left', 'right'
    ...                          - percent_start: start position as percentage (0-1) of container dimension
    ...                          - percent_end: end position as percentage (0-1) of container dimension
    ...                          - duration: swipe duration in milliseconds
    ...                          - timeout: timeout in seconds to wait for container visibility
    [Arguments]    ${container}    ${swipe_config}
    TRY
        AppiumLibrary.Wait Until Page Contains Element    ${container}    ${swipe_config['timeout']}
        AppiumLibrary.Wait Until Element Is Visible    ${container}    ${swipe_config['timeout']}
        ${size}=      AppiumLibrary.Get Element Size        ${container}
        ${location}=  AppiumLibrary.Get Element Location    ${container}
        IF    '${swipe_config['direction']}' == 'down'
            ${start_x}=    BuiltIn.Evaluate    ${size['width']}*0.5
            ${start_y}=    BuiltIn.Evaluate    ${size['height']}*${swipe_config['percent_start']}+${location['y']}
            ${end_x}=      BuiltIn.Set Variable    ${start_x}
            ${end_y}=      BuiltIn.Evaluate    ${size['height']}*${swipe_config['percent_end']}+${location['y']}
        ELSE IF    '${swipe_config['direction']}' == 'up'
            ${start_x}=    BuiltIn.Evaluate    ${size['width']}*0.5
            ${start_y}=    BuiltIn.Evaluate    ${size['height']}*${swipe_config['percent_end']}+${location['y']}
            ${end_x}=      BuiltIn.Set Variable    ${start_x}
            ${end_y}=      BuiltIn.Evaluate    ${size['height']}*${swipe_config['percent_start']}+${location['y']}
        ELSE IF    '${swipe_config['direction']}' == 'left'
            ${start_x}=    BuiltIn.Evaluate    ${size['width']}*${swipe_config['percent_end']}+${location['x']}
            ${start_y}=    BuiltIn.Evaluate    ${size['height']}*0.5+${location['y']}
            ${end_x}=      BuiltIn.Evaluate    ${size['width']}*${swipe_config['percent_start']}+${location['x']}
            ${end_y}=      BuiltIn.Set Variable    ${start_y}
        ELSE IF    '${swipe_config['direction']}' == 'right'
            ${start_x}=    BuiltIn.Evaluate    ${size['width']}*${swipe_config['percent_start']}+${location['x']}
            ${start_y}=    BuiltIn.Evaluate    ${size['height']}*0.5+${location['y']}
            ${end_x}=      BuiltIn.Evaluate    ${size['width']}*${swipe_config['percent_end']}+${location['x']}
            ${end_y}=      BuiltIn.Set Variable    ${start_y}
        ELSE
            Fail    Invalid swipe direction: ${swipe_config['direction']}
        END
        AppiumLibrary.Swipe
        ...    start_x=${start_x}
        ...    start_y=${start_y}
        ...    end_x=${end_x}
        ...    end_y=${end_y}
        ...    duration=${swipe_config['duration']}
    EXCEPT
        BuiltIn.Log    Element '${container}' is not visible, skipped    level=ERROR
    END

Swipe until element visible
    [Documentation]
    ...    Performs repeated swipes inside a container until a target element becomes visible
    ...    or until the maximum number of swipes is reached.
    ...    [Arguments]
    ...    ${container}         The locator of the container element to perform the swipes in.
    ...    ${target_element}    The locator of the target element to wait for.
    ...    ${swipe_config}       A dictionary containing swipe parameters:
    ...                          - direction: 'up', 'down', 'left', 'right'
    ...                          - percent_start: start position as percentage (0-1) of container dimension
    ...                          - percent_end: end position as percentage (0-1) of container dimension
    ...                          - duration: swipe duration in milliseconds
    ...                          - timeout: timeout in seconds to wait for container/target element visibility
    ...                          - max_swipes: maximum number of swipes to attempt
    [Arguments]    ${container}    ${target_element}    ${swipe_config}
    ${swipe_count}=    BuiltIn.Set Variable    0
    TRY
        AppiumLibrary.Wait Until Page Contains Element    ${container}    ${swipe_config['timeout']}
        AppiumLibrary.Wait Until Element Is Visible    ${container}    ${swipe_config['timeout']}
        WHILE    ${swipe_count} < ${swipe_config['max_swipes']}
            Swipe In Direction
            ...    ${container}
            ...    ${swipe_config}
            ${is_visible}=    BuiltIn.Run Keyword And Return Status
            ...    AppiumLibrary.Wait Until Element Is Visible    ${target_element}    ${swipe_config['timeout']}
            IF    ${is_visible}
                BREAK
            END
            ${swipe_count}=    BuiltIn.Evaluate    ${swipe_count} + 1
        END
    EXCEPT
        BuiltIn.Log    Element '${container}' is not visible, skipped    level=ERROR
    END

# Wait Until Element Visible

# Get Text From Element

# Verify Element Exist

# Clear Input Field

# Press Device Back

# Capture App Screenshot
