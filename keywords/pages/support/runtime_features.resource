*** Settings ***
Documentation    Shared helpers for loading YAML configuration and localized strings.
Library    Collections
Library    OperatingSystem
Library    String

*** Variables ***
${PROJECT_ROOT}    ${CURDIR}/../../..
${CONFIG_DIR}      ${PROJECT_ROOT}/configs
${DATA_DIR}        ${PROJECT_ROOT}/data
${LOCALE_DIR}      ${DATA_DIR}/locales

*** Keywords ***
Load yaml file
    [Documentation]    Loads YAML file and returns parsed content.
    [Arguments]    ${path}
    ${normalized}=    OperatingSystem.Normalize Path    ${path}
    OperatingSystem.File Should Exist    ${normalized}
    ${data}=    BuiltIn.Evaluate
    ...    __import__('yaml').safe_load(__import__('pathlib').Path(r'''${normalized}''').read_text(encoding='utf-8'))
    ...    modules=yaml,pathlib
    RETURN    ${data}

Get environment config
    [Documentation]    Returns environment data for the selected platform/env.
    [Arguments]    ${platform}    ${env_name}
    ${env_path}=    OperatingSystem.Join Path    ${CONFIG_DIR}    environments.yaml
    ${data}=    Load yaml file    ${env_path}
    ${platform_block}=    Collections.Get From Dictionary    ${data}    ${platform}
    ${env_config}=    Collections.Get From Dictionary    ${platform_block}    ${env_name}
    RETURN    ${env_config}

Get browser profile
    [Documentation]    Returns browser profile definition by name.
    [Arguments]    ${profile_name}
    ${path}=    OperatingSystem.Join Path    ${CONFIG_DIR}    browsers.yaml
    ${data}=    Load yaml file    ${path}
    ${profiles}=    Collections.Get From Dictionary    ${data}    profiles
    ${profile}=    Collections.Get From Dictionary    ${profiles}    ${profile_name}
    RETURN    ${profile}

Get device profile
    [Documentation]    Returns device capabilities for profile path format platform.profile.
    [Arguments]    ${profile_path}
    ${segments}=    String.Split String    ${profile_path}    .
    ${platform}=    Collections.Get From List    ${segments}    0
    ${name}=        Collections.Get From List    ${segments}    1
    ${path}=    OperatingSystem.Join Path    ${CONFIG_DIR}    devices.yaml
    ${data}=    Load yaml file    ${path}
    ${devices}=    Collections.Get From Dictionary    ${data}    devices
    ${platform_devices}=    Collections.Get From Dictionary    ${devices}    ${platform}
    ${device}=    Collections.Get From Dictionary    ${platform_devices}    ${name}
    RETURN    ${device}

Get app profile
    [Documentation]    Returns app metadata defined in devices.yaml -> apps.
    [Arguments]    ${app_profile}
    ${path}=    OperatingSystem.Join Path    ${CONFIG_DIR}    devices.yaml
    ${data}=    Load yaml file    ${path}
    ${apps}=    Collections.Get From Dictionary    ${data}    apps
    ${app}=    Collections.Get From Dictionary    ${apps}    ${app_profile}
    RETURN    ${app}

Get localized text
    [Documentation]    Loads the locale YAML for `language_code` and resolves the dot-delimited key.
    [Arguments]    ${language_code}    ${key_path}
    ${file_name}=    BuiltIn.Evaluate    f"{language_code}.yaml"
    ${path}=    OperatingSystem.Join Path    ${LOCALE_DIR}    ${file_name}
    ${locale}=    Load yaml file    ${path}
    ${segments}=    String.Split String    ${key_path}    .
    ${current}=    BuiltIn.Set Variable    ${locale}
    FOR    ${segment}    IN    @{segments}
        ${is_index}=    BuiltIn.Run Keyword And Return Status
        ...    Should Match Regexp
        ...    ${segment}
        ...    ^-?\d+$
        IF    ${is_index}
            ${idx}=    BuiltIn.Convert To Integer    ${segment}
            ${current}=    Collections.Get From List    ${current}    ${idx}
        ELSE
            ${current}=    Collections.Get From Dictionary    ${current}    ${segment}
        END
    END
    RETURN    ${current}
