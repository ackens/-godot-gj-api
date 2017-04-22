# GameJolt API plugin for Godot Engine.

## About
**The plugin has been rewritten! New features include:**
* Parameters to the api calls can be passed both as strings and numbers
* Rewritten from ground up, thus smaller main plugin script
* Some functions have been merged
* URLs are now percent encoded

The old plugin is still available with all of its documentation in this repository.

**Installing**
1. Download the repository
2. Create the "addons" folder in the root (res://) of your project
3. Copy the "gamejolt_api_v2" to that folder
4. In the project settings, head to the "Plugins" tab and activate the plugin by changing its state from "Inactive" to "Active"
5. Yay, you've installed the plugin!

**Plugin's output**

The gamejolt api outputs data as json strings. When requesting a lot of data, this string becomes quite large. The plugin could pre-parse this data in some way to give the user a nicely organized dictionary with the received data instead of just raw json string. But it doesn't. There is reasoning behind this:
* Parsing raw json strings received from the api requires writing addotoinal code in the plugin
* Most people will find this more preferable since different games deal with the received information in different ways and outputting raw json strings gives more freedom in manipulating that data than pre-parsing it before finally giving it to the user
* Parsing json strings is very easy in Godot, so it's usually not a problem

# Methods description

## Authentication and users
**Before doing calls that deal with users in one way or another, you must authenticate a user to ensure that the username-token pair is valid.**

`auth_user(token, username)` - authenticates the user with the given credentials
* token - your gamejolt token (not your password)
* username - your gamejolt username

Signal: `api_authenticated(success)`

**When you've successfully authenticated the user, you can do a lot of cool things. For example, you can fetch a user's information.**

`fetch_user(username='', id=0):` - outputs a user's information
* username - name of the user, whose information you'd like to fetch
* id - id of the user, whose information you'd like to fetch

You don't need to pass both arguments, but at least one argument must be passed! When using ids, multiple ids can be passed, like this: '1,2,3,4'

Signal: `api_user_fetched(data)`
## Sessions
**Sessions are used to tell gamejolt that someone's playing your game. Opening a session is easy.**

`open_session()` - opens a session

Piece of cake! If there's an active session, it will close it and open a new one.

Signal: `api_session_opened(success)`

**A session is closed after 120 seconds if not pinged. You have to ping the session to prevent it from closing.**

`ping_session()` - pings a session

Usually a timer that pings the session every 60 seconds will do the trick.

Signal: `api_session_pinged(success)`

**When the player quits the game, the session should be closed.**

`close_session()` - closes the active session

If the game is closed, the session will be closed automatically anyway since it's not being pinged, but it's better to close it manually with this method, just in case.

Signal: `api_session_closed(success)`
## Trophies a.k.a achievements
**Trophies are basically achievements, nothing unusual. Fetching a list of trophies, just one trophy, only achieved trophies or only the unachieved trophies is done through this supermethod.**

`fetch_trophy(achieved='', trophy_ids=0)` - fetches trophies
* achieved - leave blank to extarct all trophies, "true" to extract only trophies that the user has already achieved and "false" to get only unachieved trophies
* trophy_ids - pass a trophy id to extract the specific trophy or a set of trophy ids to get a list of trophies, like this: '1,2,3,4'

If the second parameter is passed, the first one is ignored!

Signal: `api_trophy_fetched(data)`

**To set a trophy as achieved.**

`set_trophy_achieved(trophy_id)` - sets the trophy as achieved
* trophy_id - id of the trophy to set as achieved

Signal: `api_trophy_set_achieved(success)`

## Scores
**Scoreboards are another important part of the api. Extracting scores for the game is straightforward.**

`fetch_scores(username='', token='', limit=0, table_id=0)` - fetches scores for the game
* username and token - only pass these parameters if you'd like to fetch scores for the user. Leaving them blank will retrieve scores globally
* limit - how many scores to return. The default value is 10, the max is 100
* table_id - what table to extract scores from. Leaving it blank will extract scores from the main table

Only pass the parameters you need! If you want scores globally for the game, leave username and token blank! If you want scores from the main scoreboard, leave table_id blank and so on...

Signal: `api_scores_fetched(data)`

**Being able to fetch scores is nice, but firstly we need to populate scoreboards with the actual score entries!**

`add_score(score, sort, username='', token='', guest='', table_id=0)` - adds a score to a table
* score - string assotiated with the score. For instance: "124 Jumps"
* sort - the actual score value. For example: 124
* username and token - only pass these parameters if you'd like to add scores for the user. If you leave them blank, the "guest" parameter must be passed
* guest - only pass this parameter if you'd like to store a score as a guest. If you leave this blank, "username" and "token" parameters must be passed
* table_id - what table to submit scores to. If left blank, the score will be submitted to the main table

Signal: `api_scores_added(success)`

**If you need to know what scoreboards are there, call this method.**

`fetch_tables()` - returns a list of all scoreboards

Signal: `api_tables_fetched(data)`

## Data storage
**GameJolt allows you to store data...in the *cloud*! To store some data in the cloud call this method.**

`set_data(key, data, username='', token='')` - stores data in the cloud
* key - a piece of data is stored in a *key*, this is the name of the key
* data - what you want to store in the key
* username and token - only pass these parameters if you want to store the data for the user

Data can be strings, integers, floats...anything

Signal: `api_data_set(success)`

**Fetching data from a key is easy too.**

`fetch_data(key, username='', token='')` - fetches data from the key
* key - key to fetch data from
* username and token - only pass these parameters if you want data from the user

Signal: `api_data_fetched(data)`

**Everything changes. The data in a key changes too when you update it with this method.**

`update_data(key, operation, value, username='', token='')` - updates data in the key
* key - key, whose data will be updated
* operation - what kind of operation to perform on the data. String can be prepended and appended to. Numbers can be divided, multiplied, added to and subtracted from. Use one of these: "append", "prepend", "divide", "multiply", "add", "subtract"
* value = value that will be used in the operation
* username and token - only pass these parameters if you want to update the user's data. Otherwise it will be updated globally for the game

Signal: `api_data_updated(new_data)`

**One day, you might want to remove a key. Fortunately, that's totally possible! Just one call and the key is erased from existence!**

`remove_data(key, username='', token='')` - removes a key
* key - what key to remove
* username and token - only pass these parameters if you want to remove the key for the user

Signal: `api_data_removed(success)`

**Obtaining a list of all data keys is totally possible too!**

`get_data_keys(username='', token='')` - return a list of all keys
* username and token - only pass these parameters if you want to get list of keys for the user

Signal: `api_data_got_keys(data)`

# Additional methods

* get_username() - returns username
* get_user_token() - return the user's token

# Avatars-related functionality will be added later
