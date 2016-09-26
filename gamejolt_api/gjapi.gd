extends HTTPRequest

# Game Jolt GDScript-ified API by Ackens
# See this link for reference: http://gamejolt.com/api/doc/game
# TODO before publication: separate methods by arguments, add username caching, add errors

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
signal on_api_auth(data) # On user authenticated
signal on_api_fetch_user(data) # On user(-s) info fetched
signal on_api_session_open(data) # On session opened
signal on_api_session_ping(data) # On session pinged
signal on_api_session_close(data) # On session closed
signal on_api_fetch_trophy(data) # On trophy(-ies) fetched
signal on_api_add_trophy(data) # On trophy added
signal on_api_fetch_scores(data) # On scores fetched
signal on_api_add_score(data) # On score added
signal on_api_fetch_tables(data) # On score tables fetched
export(String) var private_key
export(String) var game_id
var request_type

func _ready():
	connect("request_completed", self, "request_completed")
	pass
	
# Authentication/users--
func _auth_user(token, username):
	var rawurl = AUTH + "?game_id=" + str(game_id) + "&username=" + username + "&user_token=" + token + "&format=json"
	var signature = rawurl + private_key
	signature = signature.md5_text()
	request_type = "auth"
	request(rawurl + "&signature=" + signature)
	pass
	
func _fetch_user(username="", user_id=""): # multiple user ids allowed, comma-separated
	var rawurl
	if username != "":
		rawurl = USERS + "?game_id=" + str(game_id) + "&username=" + username + "&format=json"
	else:
		rawurl = USERS + "?game_id=" + str(game_id) + "&user_id=" + str(user_id) + "&format=json"
	var signature = rawurl + private_key
	signature = signature.md5_text()
	request_type = "fetch_user"
	request(rawurl + "&signature=" + signature)
	pass
	
# Session opening/pinging/closing--
func _open_session(username, token):
	var rawurl = SESSION_OPEN + "?game_id=" + str(game_id) + "&username=" + username + "&user_token=" + token + "&format=json"
	var signature = rawurl + private_key
	signature = signature.md5_text()
	request_type = "session_open"
	request(rawurl + "&signature=" + signature)
	pass
	
func _ping_session(username, token):
	var rawurl = SESSION_PING + "?game_id=" + str(game_id) + "&username=" + username + "&user_token=" + token + "&format=json"
	var signature = rawurl + private_key
	signature = signature.md5_text()
	request_type = "session_ping"
	request(rawurl + "&signature=" + signature)
	pass
	
func _close_session(username, token):
	var rawurl = SESSION_CLOSE + "?game_id=" + str(game_id) + "&username=" + username + "&user_token=" + token + "&format=json"
	var signature = rawurl + private_key
	signature = signature.md5_text()
	request_type = "session_close"
	request(rawurl + "&signature=" + signature)
	pass
	
# Trophies fetching/adding--
func _fetch_trophies(username, token, achieved="", trophy_ids=""): # achieved=true/false/""
	var rawurl
	if str(trophy_ids) != "":
		rawurl = TROPHIES + "?game_id=" + str(game_id) + "&username=" + username + "&user_token=" + token + "&achieved=" + achieved + "&trophy_id=" + str(trophy_ids) + "&format=json"
	else:
		rawurl = TROPHIES + "?game_id=" + str(game_id) + "&username=" + username + "&user_token=" + token + "&achieved=" + achieved + "&format=json"
	var signature = rawurl + private_key
	signature = signature.md5_text()
	request_type = "fetch_trophy"
	request(rawurl + "&signature=" + signature)
	pass
	
func _add_trophy(username, token, trophy_id):
	var rawurl = TROPHY_ADD + "?game_id=" + str(game_id) + "&username=" + username + "&user_token=" + token + "&trophy_id=" + str(trophy_id) + "&format=json"
	var signature = rawurl + private_key
	signature = signature.md5_text()
	request_type = "add_trophy"
	request(rawurl + "&signature=" + signature)
	pass
	
# Scores and related--
func _fetch_scores(username="", token="", limit="", table_id=""):
	var rawurl
	if username != "" and token != "":
		rawurl = SCORES + "?game_id=" + str(game_id) + "&username=" + username + "user_token=" + token + "&limit=" + str(limit) + "&format=json"
	else:
		rawurl = SCORES + "?game_id=" + str(game_id) + "&limit=" + str(limit) + "&format=json"
	if str(table_id) != "":
		rawurl += "&table_id=" + str(table_id)
	var signature = rawurl + private_key
	signature = signature.md5_text()
	request_type = "fetch_scores"
	request(rawurl + "&signature=" + signature)
	pass
	
func _add_score(score, sort, username="", token="", guest="", table_id=""):
	var rawurl
	if username != "" and token != "":
		rawurl = SCORES_ADD + "?game_id=" + str(game_id) + "&score=" + score + "&sort=" + str(sort) + "&username=" + username + "&user_token=" + token + "&format=json"
	elif guest != "":
		rawurl = SCORES_ADD + "?game_id=" + str(game_id) + "&score=" + score + "&sort=" + str(sort) + "&guest=" + guest + "&format=json"
	if str(table_id) != "":
		rawurl += "&table_id=" + str(table_id)
	var signature = rawurl + private_key
	signature = signature.md5_text()
	request_type = "add_score"
	request(rawurl + "&signature=" + signature)
	pass
	
func _fetch_tables():
	var rawurl = SCORES_TABLES + "?game_id=" + str(game_id) + "&format_json"
	var signature = rawurl + private_key
	signature = signature.md5_text()
	request_type = "fetch_tables"
	request(rawurl + "&signature=" + signature)
	pass
	
func request_completed(result, response_code, headers, body):
	var res = body.get_string_from_ascii()
	emit_signal("on_api_" + request_type, res)
	pass