*** Settings ***
Variables    ../Config/config.py
Library      RequestsLibrary


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
    [Documentation]    Test the retrieval of all posts
    ${response}=    GET    ${POSTS_URL}    headers=${HEADERS}
    Should Be Equal As Numbers    ${response.status_code}    200

Get Post by ID
    [Documentation]    Test retrieving a post by its ID
    ${response}=    GET    ${POSTS_URL}/1    headers=${HEADERS}
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Contain    ${response.json()}    title

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


