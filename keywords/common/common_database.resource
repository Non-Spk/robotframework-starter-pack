*** Settings ***
Documentation    Shared database helper keywords.


*** Keywords ***
Connect to database
    [Documentation]
    ...    Connects to a database using the given configuration dictionary `${config_db}`.
    ...    The dictionary can contain the following keys:
    ...        - db_module: database module (e.g., psycopg2, pymysql)
    ...        - db_name: database name (optional, default empty)
    ...        - db_user: username (optional, default empty)
    ...        - db_password: password (optional, default empty)
    ...        - db_host: host (optional, default empty)
    ...        - db_port: port (optional, default empty)
    ...    If a key is missing, an empty string `''` will be used as default.
    ...    Returns True if connection is successful, False otherwise.
    [Arguments]    ${alias}    ${config_db}
    ${db_module}=    Collections.Get From Dictionary    ${config_db}    db_module    ''
    ${db_name}=      Collections.Get From Dictionary    ${config_db}    db_name      ''
    ${db_user}=      Collections.Get From Dictionary    ${config_db}    db_user      ''
    ${db_password}=  Collections.Get From Dictionary    ${config_db}    db_password  ''
    ${db_host}=      Collections.Get From Dictionary    ${config_db}    db_host      ''
    ${db_port}=      Collections.Get From Dictionary    ${config_db}    db_port      ''
    ${status}=    BuiltIn.Run Keyword And Return Status
    ...    DatabaseLibrary.Connect To Database
    ...    db_module=${db_module}
    ...    db_name=${db_name}
    ...    db_user=${db_user}
    ...    db_password=${db_password}
    ...    db_host=${db_host}
    ...    db_port=${db_port}
    ...    alias=${alias}
    ${connect_log}=    BuiltIn.Create Dictionary    status=${status}    alias=${alias}
    RETURN    ${connect_log}

Disconnect to database
    [Documentation]    Disconnect from database with ${alias}
    [Arguments]    ${alias}
    DatabaseLibrary.Disconnect From Database    alias=${alias}

Execute query
    [Documentation]
    ...    Executes a generic SQL query using the specified database connection alias.
    ...    Automatically commits if the query modifies data.
    [Arguments]    ${alias}    ${query}    @{args}
    DatabaseLibrary.Execute Sql String    ${query}    alias=${alias}    parameters=${args}

Fetch one record
    [Documentation]
    ...    Executes a SELECT query and returns the first record from the result set.
    ...    Returns an empty list if no record is found.
    [Arguments]    ${alias}    ${query}    @{args}
    ${result}=    DatabaseLibrary.Query    ${query}    alias=${alias}    parameters=${args}
    ${record}=    BuiltIn.Set Variable If    ${result}    ${result[0]}    ${EMPTY}
    RETURN    ${record}

Fetch all records
    [Documentation]
    ...    Executes a SELECT query and returns all records from the result set.
    ...    Returns an empty list if no records are found.
    [Arguments]    ${alias}    ${query}    @{args}
    ${result}=    DatabaseLibrary.Query    ${query}    alias=${alias}    parameters=${args}
    RETURN    ${result}

Verify record exists
    [Documentation]
    ...    Verifies that a record exists in the database for the given query.
    ...    Fails if no record is found.
    [Arguments]    ${alias}    ${query}    @{args}
    ${result}=    DatabaseLibrary.Query    ${query}    alias=${alias}    parameters=${args}
    BuiltIn.Should Not Be Empty    ${result}    No records found for query: ${query}

Verify value in result
    [Documentation]
    ...    Verifies that a specific value exists in the result set from the query.
    ...    Fails if the expected value is not found.
    [Arguments]    ${alias}    ${query}    ${expected_value}    @{args}
    ${result}=    DatabaseLibrary.Query    ${query}    alias=${alias}    parameters=${args}
    ${flat_result}=    BuiltIn.Evaluate    [item for row in ${result} for item in row]
    BuiltIn.Should Contain    ${flat_result}    ${expected_value}
    ...    Expected value '${expected_value}' not found in result.

Insert data
    [Documentation]    Executes an INSERT SQL statement (auto-commit).
    [Arguments]    ${alias}    ${query}    @{args}
    DatabaseLibrary.Execute Sql String    ${query}    alias=${alias}    parameters=${args}

Update data
    [Documentation]    Executes an UPDATE SQL statement (auto-commit).
    [Arguments]    ${alias}    ${query}    @{args}
    DatabaseLibrary.Execute Sql String    ${query}    alias=${alias}    parameters=${args}

Delete data
    [Documentation]    Executes a DELETE SQL statement (auto-commit).
    [Arguments]    ${alias}    ${query}    @{args}
    DatabaseLibrary.Execute Sql String    ${query}    alias=${alias}    parameters=${args}
