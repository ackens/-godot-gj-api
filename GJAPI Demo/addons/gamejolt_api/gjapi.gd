extends HTTPRequest

# Game Jolt GDScript-ified API by Ackens
# See this link for reference: http://gamejolt.com/api/doc/game

const AUTH = "http://gamejolt.com/api/game/v1/users/auth/"
const USERS = "http://gamejolt.com/api/game/v1/users/"
const SESSION_OPEN = "http://gamejolt.com/api/game/v1/sessions/open/"
const SESSION_PING = "http://gamejolt.com/api/game/v1/sessions/ping/"
const SESSION_CLOSE = "http://gamejolt.com/api/game/v1/sessions/close/"
const TROPHIES = "http://gamejolt.com/api/game/v1/trophies/"
const TROPHY_ADD = "http://gamejolt.com/api/game/v1/trophies/add-achieved/"
const SCORES = "http://gamejolt.com/api/game/v1/scores/"
const SCORES_ADD = "http://gamejolt.com/api/game/v1/scores/add/"
const SCORES_TABLES = "http://gamejolt.com/api/game/v1/scores/tables/"
signal api_authenticated(data) # On user authenticated
signal api_user_fetched(data) # On user(-s) info fetched
signal api_session_opened(data) # On session opened
signal api_session_pinged(data) # On session pinged
signal api_session_closed(data) # On session closed
signal api_trophy_fetched(data) # On trophy(-ies) fetched
signal api_trophy_added(data) # On trophy added
signal api_score_fetched(data) # On scores fetched
signal api_score_added(data) # On score added
signal api_tables_fetched(data) # On score tables fetched
export(String) var private_key
export(String) var game_id
var request_type
var busy = false
var username_cache
var token_cache

func _ready():
	connect("request_completed", self, "request_completed")
	pass
	
# Authentication/users--
func auth_user(token, username): # call this before any further calls to the api
	if busy: return
	busy = true
	var url = AUTH + "?game_id=" + str(game_id) + "&username=" + username + "&user_token=" + token + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "authenticated"
	username_cache = username
	token_cache = token
	request(url + "&signature=" + signature)
	pass
	
func fetch_user_by_name(username):
	if busy: return
	busy = true
	var url
	url = USERS + "?game_id=" + str(game_id) + "&username=" + username + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "user_fetched"
	request(url + "&signature=" + signature)
	pass
	
func fetch_user_by_id(user_id): # multiple user ids allowed, comma-separated 1,2,3,4
	if busy: return
	busy = true
	var url
	url = USERS + "?game_id=" + str(game_id) + "&user_id=" + str(user_id) + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "user_fetched"
	request(url + "&signature=" + signature)
	pass
	
# Session opening/pinging/closing--
func open_session():
	if busy: return
	busy = true
	var url = SESSION_OPEN + "?game_id=" + str(game_id) + "&username=" + username_cache + "&user_token=" + token_cache + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "session_opened"
	request(url + "&signature=" + signature)
	pass
	
func ping_session():
	if busy: return
	busy = true
	var url = SESSION_PING + "?game_id=" + str(game_id) + "&username=" + username_cache + "&user_token=" + token_cache + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "session_pinged"
	request(url + "&signature=" + signature)
	pass
	
func close_session():
	if busy: return
	busy = true
	var url = SESSION_CLOSE + "?game_id=" + str(game_id) + "&username=" + username_cache + "&user_token=" + token_cache + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "session_closed"
	request(url + "&signature=" + signature)
	pass
	
# Trophies fetching/adding--
func fetch_trophies(achieved="", trophy_ids=""): # achieved=true/false/""
	if busy: return
	busy = true
	var url
	if str(trophy_ids) != "":
		url = TROPHIES + "?game_id=" + str(game_id) + "&username=" + username_cache + "&user_token=" + token_cache + "&achieved=" + achieved + "&trophy_id=" + str(trophy_ids) + "&format=json"
	else:
		url = TROPHIES + "?game_id=" + str(game_id) + "&username=" + username_cache + "&user_token=" + token_cache + "&achieved=" + achieved + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "trophy_fetched"
	request(url + "&signature=" + signature)
	pass
	
func add_trophy(trophy_id):
	if busy: return
	busy = true
	var url = TROPHY_ADD + "?game_id=" + str(game_id) + "&username=" + username_cache + "&user_token=" + token_cache + "&trophy_id=" + str(trophy_id) + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "trophy_added"
	request(url + "&signature=" + signature)
	pass
	
# Scores and related--
func fetch_scores(limit="", table_id=""):
	if busy: return
	busy = true
	var url
	url = SCORES + "?game_id=" + str(game_id) + "&limit=" + str(limit) + "&format=json"
	if str(table_id) != "":
		url += "&table_id=" + str(table_id)
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "score_fetched"
	request(url + "&signature=" + signature)
	pass
	
func fetch_scores_for_user(limit="", table_id=""):
	if busy: return
	busy = true
	var url
	url = SCORES + "?game_id=" + str(game_id) + "&username=" + username_cache + "user_token=" + token_cache + "&limit=" + str(limit) + "&format=json"
	if str(table_id) != "":
		url += "&table_id=" + str(table_id)
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "score_fetched"
	request(url + "&signature=" + signature)
	pass
	
func add_score_for_guest(score, sort, guest, table_id=""):
	if busy: return
	busy = true
	var url
	url = SCORES_ADD + "?game_id=" + str(game_id) + "&score=" + score + "&sort=" + str(sort) + "&guest=" + guest + "&format=json"
	if str(table_id) != "":
		url += "&table_id=" + str(table_id)
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "score_added"
	request(url + "&signature=" + signature)
	pass
	
func add_score_for_user(score, sort, table_id=""):
	if busy: return
	busy = true
	var url
	url = SCORES_ADD + "?game_id=" + str(game_id) + "&score=" + score + "&sort=" + str(sort) + "&username=" + username_cache + "&user_token=" + token_cache + "&format=json"
	if str(table_id) != "":
		url += "&table_id=" + str(table_id)
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "score_added"
	request(url + "&signature=" + signature)
	pass
	
func fetch_tables():
	if busy: return
	busy = true
	var url = SCORES_TABLES + "?game_id=" + str(game_id) + "&format_json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "tables_fetched"
	request(url + "&signature=" + signature)
	pass

# Non-API functions--
func request_completed(result, response_code, headers, body):
	busy = false
	var res = body.get_string_from_ascii()
	emit_signal("api_" + request_type, res)
	pass
	
func get_username():
	return username_cache
	pass
	
func get_token():
	return token_cache
	pass