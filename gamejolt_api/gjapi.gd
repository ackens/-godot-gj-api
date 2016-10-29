 extends HTTPRequest

# Game Jolt GDScript-ified API v1.0 by Ackens
# See this link for reference: http://gamejolt.com/api/doc/game

# ---URL constants--- #
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
const DATA_SET = "http://gamejolt.com/api/game/v1/data-store/set/"
const DATA_FETCH = "http://gamejolt.com/api/game/v1/data-store/"
const DATA_UPDATE = "http://gamejolt.com/api/game/v1/data-store/update/"
const DATA_REMOVE = "http://gamejolt.com/api/game/v1/data-store/remove/"
const DATA_KEYS = "http://gamejolt.com/api/game/v1/data-store/get-keys/"
# --- Signals--- #
signal api_authenticated(success) # On user authenticated
signal api_user_fetched(userdata) # On user(-s) info fetched
signal api_session_opened(success) # On session opened
signal api_session_pinged(success) # On session pinged
signal api_session_closed(success) # On session closed
signal api_trophy_fetched(trophy_data) # On trophy(-ies) fetched
signal api_trophy_added(success) # On trophy added
signal api_score_fetched(scores) # On scores fetched
signal api_score_added(success) # On score added
signal api_tables_fetched(tables) # On score tables fetched
signal api_data_set(success) # On data store key set
signal api_data_fetched(itemdata) # On data store key fetched
signal api_data_updated(result) # On data store key updated
signal api_data_removed(success) # On data store key removed
signal api_data_got_keys(keys) # On data store keys fetched
signal got_trophy_icon(icon_path, trophy_info_json) # On trophy icon downloaded
signal got_user_avatar(path) # On avatar downloaded
signal any_request_started # When any request has started, no matter which one
signal any_request_complete # When any request has been finished, no matter which one
# ---User data--- #
export(String) var private_key
export(String) var game_id
# ---Plugin variables--- #
var request_type
var busy = false
var trophy_no = 0
var trophies_list
var def_path
# ---Caches--- #
var username_cache
var token_cache

func _ready():
	connect("request_completed", self, "request_completed")
	pass
	
# ---Authentication/users--- #
func auth_user(token, username): # call this before any further calls to the api
	if busy: return
	busy = true
	emit_signal("any_request_started")
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
	emit_signal("any_request_started")
	var url = USERS + "?game_id=" + str(game_id) + "&username=" + username + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "user_fetched"
	request(url + "&signature=" + signature)
	pass
	
func fetch_user_by_id(user_id): # multiple user ids allowed, comma-separated 1,2,3,4
	if busy: return
	busy = true
	emit_signal("any_request_started")
	var url = USERS + "?game_id=" + str(game_id) + "&user_id=" + str(user_id) + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "user_fetched"
	request(url + "&signature=" + signature)
	pass
	
# ---Session opening/pinging/closing--- #
func open_session():
	if busy: return
	busy = true
	emit_signal("any_request_started")
	var url = SESSION_OPEN + "?game_id=" + str(game_id) + "&username=" + username_cache + "&user_token=" + token_cache + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "session_opened"
	request(url + "&signature=" + signature)
	pass
	
func ping_session():
	if busy: return
	busy = true
	emit_signal("any_request_started")
	var url = SESSION_PING + "?game_id=" + str(game_id) + "&username=" + username_cache + "&user_token=" + token_cache + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "session_pinged"
	request(url + "&signature=" + signature)
	pass
	
func close_session():
	if busy: return
	busy = true
	emit_signal("any_request_started")
	var url = SESSION_CLOSE + "?game_id=" + str(game_id) + "&username=" + username_cache + "&user_token=" + token_cache + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "session_closed"
	request(url + "&signature=" + signature)
	pass
	
# ---Trophies fetching/adding--- #
func fetch_trophies(achieved="", trophy_ids=""): # achieved=true/false/""
	if busy: return
	busy = true
	emit_signal("any_request_started")
	var url
	if str(trophy_ids) != "":
		url = TROPHIES + "?game_id=" + str(game_id) + "&username=" + username_cache + "&user_token=" + token_cache + "&trophy_id=" + str(trophy_ids) + "&format=json"
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
	emit_signal("any_request_started")
	var url = TROPHY_ADD + "?game_id=" + str(game_id) + "&username=" + username_cache + "&user_token=" + token_cache + "&trophy_id=" + str(trophy_id) + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "trophy_added"
	request(url + "&signature=" + signature)
	pass
	
# ---Scores and related--- #
func fetch_scores(limit="", table_id=""):
	if busy: return
	busy = true
	emit_signal("any_request_started")
	var url = SCORES + "?game_id=" + str(game_id) + "&limit=" + str(limit) + "&format=json"
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
	emit_signal("any_request_started")
	var url = SCORES + "?game_id=" + str(game_id) + "&username=" + username_cache + "user_token=" + token_cache + "&limit=" + str(limit) + "&format=json"
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
	emit_signal("any_request_started")
	var url = SCORES_ADD + "?game_id=" + str(game_id) + "&score=" + score + "&sort=" + str(sort) + "&guest=" + guest + "&format=json"
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
	emit_signal("any_request_started")
	var url = SCORES_ADD + "?game_id=" + str(game_id) + "&score=" + score + "&sort=" + str(sort) + "&username=" + username_cache + "&user_token=" + token_cache + "&format=json"
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
	emit_signal("any_request_started")
	var url = SCORES_TABLES + "?game_id=" + str(game_id) + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "tables_fetched"
	request(url + "&signature=" + signature)
	pass
	
# ---Data store--- #
func data_store_set(key, data):
	if busy: return
	busy = true
	emit_signal("any_request_started")
	var url = DATA_SET + "?game_id=" + str(game_id) + "&key=" + key + "&data=" + str(data) + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "data_set"
	request(url + "&signature=" + signature)
	pass
	
func data_store_set_for_user(key, data):
	if busy: return
	busy = true
	emit_signal("any_request_started")
	var url = DATA_SET + "?game_id=" + str(game_id) + "&username=" + username_cache + "&user_token=" + token_cache + "&key=" + str(key) + "&data=" + str(data) + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "data_set"
	request(url + "&signature=" + signature)
	pass
	
func data_store_fetch(key):
	if busy: return
	busy = true
	emit_signal("any_request_started")
	var url = DATA_FETCH + "?game_id=" + str(game_id) + "&key=" + str(key) + "&format=dump"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "data_fetched"
	request(url + "&signature=" + signature)
	pass
	
func data_store_fetch_for_user(key):
	if busy: return
	busy = true
	emit_signal("any_request_started")
	var url = DATA_FETCH + "?game_id=" + str(game_id) + "&key=" + str(key) + "&username=" + username_cache + "&user_token=" + token_cache + "&format=dump"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "data_fetched"
	request(url + "&signature=" + signature)
	pass
	
func data_store_update(key, operation, value): # operation = add, subtract, multiply, divide, append, prepend
	if busy: return
	busy = true
	emit_signal("any_request_started")
	var url = DATA_UPDATE + "?game_id=" + str(game_id) + "&key=" + key + "&operation=" + operation + "&value=" + str(value) + "&format=dump"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "data_updated"
	request(url + "&signature=" + signature)
	pass
	
func data_store_update_for_user(key, operation, value): # operation = add, subtract, multiply, divide, append, prepend
	if busy: return
	busy = true
	emit_signal("any_request_started")
	var url = DATA_UPDATE + "?game_id=" + str(game_id) + "&key=" + key + "&operation=" + operation + "&value=" + str(value) + "&username=" + username_cache + "&user_token=" + token_cache + "&format=dump"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "data_updated"
	request(url + "&signature=" + signature)
	pass
	
func data_store_remove(key):
	if busy: return
	busy = true
	emit_signal("any_request_started")
	var url = DATA_REMOVE + "?game_id=" + str(game_id) + "&key=" + key + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "data_removed"
	request(url + "&signature=" + signature)
	pass
	
func data_store_remove_for_user(key):
	if busy: return
	busy = true
	emit_signal("any_request_started")
	var url = DATA_REMOVE + "?game_id=" + str(game_id) + "&key=" + key + "&username=" + username_cache + "&user_token=" + token_cache + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "data_removed"
	request(url + "&signature=" + signature)
	pass
	
func data_store_get_keys():
	if busy: return
	busy = true
	emit_signal("any_request_started")
	var url = DATA_KEYS + "?game_id=" + str(game_id) + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "data_got_keys"
	request(url + "&signature=" + signature)
	pass
	
func data_store_get_keys_for_user():
	if busy: return
	busy = true
	emit_signal("any_request_started")
	var url = DATA_KEYS + "?game_id=" + str(game_id) + "&username=" + username_cache + "&user_token=" + token_cache + "&format=json"
	var signature = url + private_key
	signature = signature.md5_text()
	request_type = "data_got_keys"
	request(url + "&signature=" + signature)
	pass

# ---Non-API functions--- #
func request_completed(result, response_code, headers, body):
	busy = false
	var res = body.get_string_from_ascii()
	emit_signal("any_request_complete")
	emit_signal("api_" + request_type, res)
	pass
	
func reset_busy():
	busy = false
	pass
	
# ---Additional functions--- #
func download_trophies_icons(api_trophies_json, output_folder="user://"):
	if busy: return
	busy = true
	var d = {}
	d.parse_json(api_trophies_json)
	d = d["response"]["trophies"]
	if d.empty():
		return
	emit_signal("any_request_started")
	trophies_list = d
	def_path = output_folder
	folder_exists()
	var htq = HTTPRequest.new()
	htq.set_name("icons_downloader")
	htq.connect("request_completed", self, "_next_trophy")
	add_child(htq)
	get_node("icons_downloader").set_download_file(output_folder + "trophy_icon" + str(trophy_no) + ".jpg")
	get_node("icons_downloader").request(trophies_list[trophy_no]["image_url"].replace("https", "http"))
	pass
	
func _next_trophy(result, response_code, headers, body): # callback
	emit_signal("got_trophy_icon", def_path + "trophy_icon" + str(trophy_no) + ".jpg", trophies_list[trophy_no])
	trophy_no += 1
	if trophies_list.size() == trophy_no:
		trophies_list = null
		busy = false
		get_node("icons_downloader").disconnect("request_completed", self, "_next_trophy")
		get_node("icons_downloader").queue_free()
		emit_signal("any_request_complete")
		return
	get_node("icons_downloader").set_download_file(def_path + "trophy_icon" + str(trophy_no) + ".jpg")
	get_node("icons_downloader").request(trophies_list[trophy_no]["image_url"].replace("https", "http"))
	pass
	
func download_user_avatar(api_user_json, output_folder="user://"):
	if busy: return
	busy = true
	var d = {}
	d.parse_json(api_user_json)
	d = d["response"]["users"][0]["avatar_url"]
	emit_signal("any_request_started")
	def_path = output_folder
	folder_exists()
	var htq = HTTPRequest.new()
	htq.set_name("avatar_downloader")
	htq.connect("request_completed", self, "_avatar_ready")
	add_child(htq)
	get_node("avatar_downloader").request(d.replace("https", "http"))
	pass
	
func _avatar_ready(result, response_code, headers, body): # callback
	busy = false
	var f = File.new()
	var contenttype = headers[2]
	var c = contenttype.find("image/") + 6
	c = contenttype.right(c)
	f.open(def_path + "user_avatar." + c, f.WRITE)
	f.store_buffer(body)
	f.close()
	emit_signal("got_user_avatar", def_path + "user_avatar." + c)
	emit_signal("any_request_complete")
	get_node("avatar_downloader").disconnect("request_completed", self, "_avatar_ready")
	get_node("avatar_downloader").queue_free()
	pass
	
func folder_exists():
	var d = Directory.new()
	if d.dir_exists(def_path):
		return
	d.make_dir(def_path)
	pass
	
func get_username():
	return username_cache
	pass
	
func get_token():
	return token_cache
	pass