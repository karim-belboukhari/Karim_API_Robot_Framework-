
# API link
Base_Api_Url = "https://jsonplaceholder.typicode.com"

Posts_endpoint= f"{Base_Api_Url}/posts"
Comments_endpoint = f"{Base_Api_Url}/comments"
Users_endpoint= f"{Base_Api_Url}/users"
headers1 = {
    "Content-Type": "application/json; charset=UTF-8"
}

    # The environment is production since jsonplaceholder is a public API
env= "production"

    # Timeout settings in seconds
reques_timeout = 10

