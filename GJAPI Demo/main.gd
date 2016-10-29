extends Node

var trophies_list
var trophy_no = 0
var gj
const tp = preload("res://trophy_panel.tscn")

func _ready():
	gj = get_node("gjapi")
	gj.connect("api_authenticated", self, "on_gj_auth")
	gj.connect("api_user_fetched", self, "on_gj_fetch_user")
	gj.connect("api_session_opened", self, "on_session_opened")
	gj.connect("api_trophy_fetched", self, "trophies_fetched")
	gj.connect("api_data_fetched", self, "on_data_fetched")
	gj.connect("api_data_updated", self, "on_data_updated")
	gj.connect("api_data_got_keys", self, "on_got_keys")
	pass

func on_got_keys(data):
	print(data)
	pass

func on_data_fetched(data):
	print(data)
	pass

func trophies_fetched(data):
	gj.download_trophies_icons(data, "user://icons/")
	pass

func on_session_opened(data):
	print(data)
	pass

func _on_auth_pressed():
	gj.auth_user(get_node("ui/token").get_text(), get_node("ui/username").get_text())
	get_node("ui/auth").set_text("Trying to log in with the given credentials...")
	pass # replace with function body

func on_gj_auth(data):
	get_node("ui/open_s").set_disabled(false)
	get_node("ui/close_s").set_disabled(false)
	get_node("ui/list_trophies").set_disabled(false)
	get_node("ui/auth").set_disabled(true)
	get_node("ui/auth").set_text("Logged in!")
	gj.fetch_user_by_name(gj.get_username())
	pass

func on_gj_fetch_user(data):
	var res = get_node("response")
	var d = {} # declare a dictionary
	d.parse_json(data) # parse the json string
	d = d["response"]["users"][0] # the api outputs everything in one dictionary so fetch it
	for i in d.keys(): # get all information
		res.set_text(res.get_text() + "\n" + i + ": " + d[i])
	gj.download_user_avatar(data)
	#print(data)
	pass

func _on_open_s_pressed():
	gj.open_session()
	pass # replace with function body

func _on_close_s_pressed():
	gj.close_session()
	pass # replace with function body


func _on_list_trophies_pressed():
	gj.fetch_trophies()
	pass # replace with function body

func _on_gjapi_got_trophy_icon( icon_path, trophy_info ):
	var i = load(icon_path)
	var tpi = tp.instance()
	tpi.get_node("trophy_icon").set_texture(i)
	tpi.get_node("name").set_text(trophy_info["title"])
	tpi.get_node("desc").set_text(trophy_info["description"])
	tpi.get_node("difficulty").set_text("Difficulty: " + trophy_info["difficulty"])
	get_node(trophy_info["difficulty"]).add_child(tpi)
	print("Got an icon! ", icon_path)
	pass # replace with function body

func _on_gjapi_any_request_complete():
	get_node("comms_indicator").end()
	pass # replace with function body

func _on_gjapi_any_request_started():
	get_node("comms_indicator").start()
	pass # replace with function body

func _on_gjapi_got_user_avatar( path ):
	var i = load(path)
	get_node("ui/container").show()
	get_node("ui/container/avatar").set_texture(i)
	pass # replace with function body
