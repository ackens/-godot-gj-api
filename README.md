# GameJolt API plugin for Godot Engine
## How to install
Just download the repository and drop the **gamejolt_api** folder into your addons folder. Open the add node dialog and locate **GameJoltAPI** under the HTTPRequest node. A demo project showing some of the functions is next to the plugin folder.

## How to use/methods description
### Authentication/users
Before doing any calls to the API you must authenticate a user first so the system knows what user to work with.
A method to do it is provided:

`auth_user(token, username)`
* token - your gamejolt token(NOT your password)
* username - your gamejolt username, duh

Now you can use other api methods. The api allows you to fetch user's information like their username, description and so on. You can use on of two provided methods:

`fetch_user_by_name(username)`
* username - name of the user you want to fetch

`fetch_user_by_id(user_id)`
* user_id - id of the user you want to fetch
