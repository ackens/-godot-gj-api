# You're viewing documenatation for the old vesrion, v2 recommended (in this repository)
# GameJolt API plugin for Godot Engine
## How to install/setup
Drop the **gamejolt_api** folder into your addons folder. Open the add node dialog and locate **GameJoltAPI** under the HTTPRequest node. A demo project showing some of the functions is next to the plugin folder. **Don't forget to fill in the private key and game id fields in the inspector**

![](http://imgur.com/od3ukvp.png!)

## How to use/methods description
### Authentication/users
Before doing any calls to the API you must authenticate a user so the system knows what user to work with.
A method to do it is provided:

`auth_user(token, username)`
* token - your gamejolt token (NOT your password)
* username - your gamejolt username, duh

Now you can use the rest of the API. The API allows you to fetch user's information like their username, description and so on. You can use one of the two provided methods:

`fetch_user_by_name(username)`
* username - name of the user you want to fetch

`fetch_user_by_id(user_id)`
* user_id - id of the user you want to fetch. Multiple ids allowed, comma-separated 1,2,3,4

### Sessions
Sessions are used to tell the system that someone's playing the game and to collect stats about the average game time, number of sessions... To open a session use the respective method:

`open_session()`

A session is closed within 120 seconds if not pinged. Ping your session to prevent the system from cleaning it up with the following method:

`ping_session()`

If the player wants to quit the game you might want to close the current session. Use this method to close the active session:

`close_session()`

### Trophies a.k.a achievements

GameJolt has an achievements system so you can add trophies and players can achieve them! To fetch the list of trophies for a game, call:

`fetch_trophies(achieved="", trophy_ids="")`
* achieved - if you leave this blank, all throphies will be fetched, passing true will return only the achieved trophies while passing false will return only unachieved trophies
* trophy_ids - if you pass this, only trophies with the specified ids will be fetched. You can pass multiple ids separated by a comma 1,2,3,4. If this option is passed, the first one is ignored

To set a trophy as achieved, call this:

`add_trophy(trophy_id)`
* trophy_id - the id of the trophy. Found in the game's trophies section

### Scores

GameJolt also features the scoreboards system. To fetch the scores use this method:

`fetch_scores(limit="", table_id="")`
* limit - how many scores to return. Default is 10, max is 100
* table_id - pass this if you want scores from a specified table. Scores from the primary score table are returned otherwise.

To fetch scores only of the currently logged in user use this method:

`fetch_scores_for_user(limit="", table_id="")`
* limit - how many scores to return. Default is 10, max is 100
* table_id - pass this if you want scores from a specified table. Scores from the primary scoreboard are returned otherwise.

To add a score for the user use this method:

`add_score_for_user(score, sort, table_id="")`
* score - a string value associated with the score. Example: "234 Jumps".
* sort - a numerical sorting value associated with the score. All sorting will work off of this number. Example: "234". 
* table_id - The id of the high score table that you want to submit to. If left blank the score will be submitted to the primary high score table.

Scores can be added as guest:

`add_score_for_guest(score, sort, guest, table_id="")`
* score - a string value associated with the score. Example: "234 Jumps".
* sort - a numerical sorting value associated with the score. All sorting will work off of this number. Example: "234".
* guest - name of the guest
* table_id - The id of the high score table that you want to submit to. If left blank the score will be submitted to the primary high score table.

A list of the score tables can be fetched with this method:

`fetch_tables()`

### Data store

Data store allows the developer to store strings, floats and other types of data on GameJolt servers. A chunk of data is stored in a **key**. To create a new data key and store something there call this method:

`data_store_set(key, data)`
* key - name of the key
* whatever you want to store in the key(string, float, integer etc)

To store data only for the user:

`data_store_set_for_user(key, data)`
* key - name of the key
* whatever you want to store in the key(string, float, integer etc)

To fetch the contents of a key call this:

`data_store_fetch(key)`
* key - the key to fetch data from

To fetch data only for the user:

`data_store_fetch_for_user(key)`
* key - the key to fetch data from

You can update a key, strings can be appended and prepended to and numbers can be added, subtracted, multiplied and divided. Update a key with the following method:

`data_store_update(key, operation, value)`
* key - name of the key you want to update
* operation - can be "add", "subtract", "multiply", "divide", "append", "prepend"
* value that the key will be updated with

To update a key only for the user:

`data_store_update_for_user(key, operation, value)`
* key - name of the key you want to update
* operation - can be "add", "subtract", "multiply", "divide", "append", "prepend"
* value that the key will be updated with

To remove a key and therefore it's contents:

`data_store_remove(key)`
* key - name of the key you want to remove

To remove a key for the user:

`data_store_remove_for_user(key)`
* key - name of the key you want to remove

To fetch the list of all keys call this:

`data_store_get_keys()`

To fetch keys only for the user:

`data_store_get_keys_for_user()`

### Additional functions

I implemented some useful things apart from the main API to make life a little easier.

Trophies can include an optional image which is displayed on the site in the "Trophies" section. It may be desired to download them and use in-game trophies wall, for example. It can be done with the call of this method:

`download_trophies_icons(api_trophies_json, output_folder="user://")`
* api_trophies_json - that string output by the `fetch_trophies()` call. It will be parsed for the URLs and the download will start. The signal `got_trophy_icon(icon_path, trophy_info_json)` is emmited when an icon has been downloaded and therefore triggers for each icon. The first argument is the icon's path and the second is its data as a json string.
* output_folder - where the icons will be downloaded to.

The same is for user avatars but this time it's a different method:

`download_user_avatar(api_user_json, output_folder="user://")`
* api_user_json = the string output by the `fetch_user_by_name/id()` call. It will be parsed for the URL and the download will start. The signal `got_user_avatar(path)` is emmited when the avatar has been downloaded. The first argument is the avatar's path.
* output_folder - where the image will be downloaded to.


### How to receive the API responses?

We can make calls to the API but how to receive a response? The plugin uses signals, one of the awesome features of Godot. Use the `connect()` function to connect a signal to a method. Each signal carries the "data" argument which is the response from the API. The full list of all available signals:

* **api_authenticated** - emmited when the user is authenticated
* **api_user_fetched** - emmited when user's information has been fetched
* **api_session_opened** - emmited when a session has been opened
* **api_session_pinged** - emmited when a session has been pinged
* **api_session_closed** - emmited when a session has been closed
* **api_trophy_fetched** - emmited when trophies have been fetched
* **api_trophy_added** - emmited when a trophy has been set as achieved
* **api_score_fetched** - emmited when scores have been fetched
* **api_score_added** - emmited when scores have been added to a score table
* **api_tables_fetched** - emmited when score tables have been fetched

Example: `get_node("GameJoltAPI").connect("one_of_the_above", self, "some_function")`. And your functions look like this: `func on_autheticated(response):`

Moar functions:

`get_username()` - returns username of the logged in user

`get_token()` - returns token of the logged in user
