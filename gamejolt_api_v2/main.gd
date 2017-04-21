extends HTTPRequest

# GameJolt Godot plugin by Ackens https://github.com/ackens/-godot-gj-api
# GameJolt API index page http://gamejolt.com/api/doc/game

export(String) var private_key
export(String) var game_id
var username_cache
var token_cache
var request_type
var busy = false
const PARAMETERS = {
	auth = ['*user_token=', '*username='],
	fetch_user = ['*username=', '*user_id='],
	sessions = ['*username=', '*user_token='],
	trophy_fetch = ['*username=', '*user_token=', '*achieved=', '*trophy_id='],
	trophy_add = ['*username=', '*user_token=', '*trophy_id='],
	scores_fetch = ['*username=', '*user_token=', '*limit=', '*table_id='],
	scores_add = ['*score=', '*sort=', '*username=', '*user_token=', '*guest=', '*table_id='],
	fetch_tables = [],
	fetch_data = ['*key=', '*username=', '*user_token='],
	set_data = ['*key=', '*data=', '*username=', '*user_token='],
	update_data = ['*key=', '*operation=', '*value=', '*username=', '*user_token='],
	remove_data = ['*key='],
	get_data_keys = ['*username=', '*user_token=']
}
const BASE_URLS = { 
	auth = 'http://gamejolt.com/api/game/v1/users/auth/',
	fetch_user = 'http://gamejolt.com/api/game/v1/users/',
	session_open = 'http://gamejolt.com/api/game/v1/sessions/open/',
	session_ping = 'http://gamejolt.com/api/game/v1/sessions/ping/',
	session_close = 'http://gamejolt.com/api/game/v1/sessions/close/',
	trophy = 'http://gamejolt.com/api/game/v1/trophies/',
	trophy_add = 'http://gamejolt.com/api/game/v1/trophies/add-achieved/',
	scores_fetch = 'http://gamejolt.com/api/game/v1/scores/',
	scores_add = 'http://gamejolt.com/api/game/v1/scores/add/',
	fetch_tables = 'http://gamejolt.com/api/game/v1/scores/tables/',
	fetch_data = 'http://gamejolt.com/api/game/v1/data-store/',
	set_data = 'http://gamejolt.com/api/game/v1/data-store/set/',
	update_data = 'http://gamejolt.com/api/game/v1/data-store/update/',
	remove_data = 'http://gamejolt.com/api/game/v1/data-store/remove/',
	get_data_keys = 'http://gamejolt.com/api/game/v1/data-store/get-keys/'
}
signal api_authenticated(success)
signal api_user_fetched(data)
signal api_session_opened(success)
signal api_session_pinged(success)
signal api_session_closed(success)
signal api_trophy_fetched(data)
signal api_trophy_set_achieved(success)
signal api_scores_fetched(data)
signal api_scores_added(success)
signal api_tables_fetched(data)
signal api_data_fetched(data)
signal api_data_set(success)
signal api_data_updated(new_data)
signal api_data_removed(success)
signal api_data_got_keys(data)

func _ready():
	connect("request_completed", self, '_on_HTTPRequest_request_completed')
	pass
	
func auth_user(token, username):
	if busy: return
	busy = true
	var url = compose_url('auth/auth/authenticated', [token, username])
	username_cache = username
	token_cache = token
	request(url)
	pass
	
func fetch_user(username='', id=0):
	if busy: return
	busy = true
	var url = compose_url('fetch_user/fetch_user/user_fetched', [username, id])
	print([username, id])
	request(url)
	pass
	
func open_session():
	if busy: return
	busy = true
	var url = compose_url('sessions/session_open/session_opened', [username_cache, token_cache])
	request(url)
	pass
	
func ping_session():
	if busy: return
	busy = true
	var url = compose_url('sessions/session_ping/session_pinged', [username_cache, token_cache])
	request(url)
	pass
	
func close_session():
	if busy: return
	busy = true
	var url = compose_url('sessions/session_close/session_closed', [username_cache, token_cache])
	request(url)
	pass
	
func fetch_trophy(achieved='', trophy_ids=0):
	if busy: return
	busy = true
	var url = compose_url('trophy_fetch/trophy/trophy_fetched', [username_cache, token_cache, achieved, trophy_ids])
	request(url)
	pass
	
func set_trophy_achieved(trophy_id):
	if busy: return
	busy = true
	var url = compose_url('trophy_add/trophy_add/trophy_set_achieved', [username_cache, token_cache, trophy_id])
	request(url)
	pass
	
func fetch_scores(username='', token='', limit=0, table_id=0):
	if busy: return
	busy = true
	var url = compose_url('scores_fetch/scores_fetch/scores_fetched', [username, token, limit, table_id])
	request(url)
	pass
	
func add_score(score, sort, username='', token='', guest='', table_id=0):
	if busy: return
	busy = true
	var url = compose_url('scores_add/scores_add/scores_added', [score, sort, username, token, guest, table_id])
	request(url)
	pass
	
func fetch_tables():
	if busy: return
	busy = true
	var url = compose_url('fetch_tables/fetch_tables/tables_fetched', [])
	request(url)
	pass
	
func fetch_data(key, username='', token=''):
	if busy: return
	busy = true
	var url = compose_url('fetch_data/fetch_data/data_fetched', [key, username, token])
	request(url)
	pass
	
func set_data(key, data, username='', token=''):
	if busy: return
	busy = true
	var url = compose_url('set_data/set_data/data_set', [key, data, username, token])
	request(url)
	pass
	
func update_data(key, operation, value, username='', token=''):
	if busy: return
	busy = true
	var url = compose_url('update_data/update_data/data_updated', [key, operation, value, username, token])
	request(url)
	pass
	
func remove_data(key, username='', token=''):
	if busy: return
	busy = true
	var url = compose_url('remove_data/remove_data/data_removed', [key, username, token])
	request(url)
	pass
	
func get_data_keys(username='', token=''):
	if busy: return
	busy = true
	var url = compose_url('get_data_keys/get_data_keys/data_got_keys', [username, token])
	request(url)
	pass
	
func compose_url(type, args):
	var types = type.split('/')
	request_type = types[2]
	var final_url = BASE_URLS[types[1]]
	var c = -1 # at this point of coding one of my earbuds died. one-eared music :(
	var empty_counter = 0
	for i in PARAMETERS[types[0]]:
		c += 1
		if !str(args[c]).empty() and str(args[c]) != '0':
			empty_counter += 1
			if empty_counter == 1:
				var parameter = i.replace('*', '?')
				final_url += parameter + str(args[c]).percent_encode()
			else:
				var parameter = i.replace('*', '&')
				final_url += parameter + str(args[c]).percent_encode()
	if empty_counter == 0:
		final_url += '?format=json'
	else:
		final_url += '&format=json'
	final_url += '&game_id=' + str(game_id)
	var s = final_url + private_key
	s = s.md5_text()
	print(final_url + '&signature=' + s)
	return final_url + '&signature=' + s
	pass
	
func get_username():
	return username_cache
	pass
	
func get_user_token():
	return token_cache
	pass

func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	busy = false
	emit_signal('api_' + request_type, body.get_string_from_ascii())
	pass # replace with function body