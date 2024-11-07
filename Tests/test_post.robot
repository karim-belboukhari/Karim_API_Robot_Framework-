*** Settings ***
Variables    ../Config/config.py
Library     RequestsLibrary
Library     Collections



*** Variables ***
${API_URL}        ${Base_Api_Url}
${POSTS_URL}      ${Posts_endpoint}
${HEADERS}        ${headers1}

*** Test Cases ***
Verify Variables
    Log To Console    ${API_URL}
    Log To Console  ${POSTS_URL}
    Log To Console   ${HEADERS}

Get All Posts
    [Documentation]    Test the retrieval of all posts and verify response details.
    ${response}=    GET    ${POSTS_URL}    headers=${HEADERS}

    #my assertions to validate response
    Should Be Equal As Numbers        ${response.status_code}    200
    Should Be True                    ${response.elapsed.total_seconds()} < 2    Response time is too high
    Dictionary Should Contain Key     ${response.headers}    Content-Type
    Should Be Equal                   ${response.headers["Content-Type"]}    application/json; charset=utf-8
    Should Be True                    len(${response.json()}) > 2        Response body is empty

    # here i create this loop as assertion on the response list of posts and fields
    FOR    ${post}    IN    @{response.json()}
    # Checking if "id" is an integer by verifying its type using Python's type() via Evaluate
    ${id_type}=    Evaluate    type(${post["id"]})    # This will return <class 'int'> or <class 'str'>
    Should Be Equal As Strings    ${id_type}    <class 'int'>    ID is not an integer
    
    ${title_type}=    Evaluate    type('${post["title"]}').__name__    # Ensure 'post["title"]' is properly quoted inside the expression
    # checking the "title" is a string
    Should Be Equal As Strings    ${title_type}    str    Title is not a string
    # Assert that the title is not empty
    Should Not Be Empty    ${post["title"]}    Title field is empty
    END



Get Post by ID
    
    [Documentation]    Test retrieving a post by its ID
    ${response}=    GET    ${POSTS_URL}/1    headers=${HEADERS}
    #my assertions to validate response by ID
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Be True                ${response.elapsed.total_seconds()} < 2    Response time is too high
    Should Contain                ${response.json()}    title
    Dictionary Should Contain Key         ${response.headers}        Content-Type
    Should Be Equal               ${response.headers["Content-Type"]}      application/json; charset=utf-8
    Should Be True                isinstance(${response.json()["id"]}, int)    ID not an int
    ${title_type}=    Evaluate    type("${response.json()['title']}").__name__
    Should Be Equal As Strings    ${title_type}    str    Title is not a string
    Should Not Be Empty           ${response.json()["title"]}


Create Post
    [Documentation]    Test creating a new post
    ${data}=    Create Dictionary    title=foo    body=bar    userId=1
    ${response}=    POST    ${POSTS_URL}    headers=${HEADERS}    json=${data}
    Should Be Equal As Numbers    ${response.status_code}    201

Update Post
    [Documentation]    Test updating a post
    ${data}=    Create Dictionary    title=foo updated    body=bar updated    userId=1
    ${response}=    PUT    ${POSTS_URL}/1    headers=${HEADERS}    json=${data}
    Should Be Equal As Numbers    ${response.status_code}    200

Delete Post
    [Documentation]    Test deleting a post
    ${response}=    DELETE    ${POSTS_URL}/1    headers=${HEADERS}
    Should Be Equal As Numbers    ${response.status_code}    200


