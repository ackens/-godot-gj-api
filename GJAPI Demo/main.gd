extends Node

var trophies_list
var trophy_no = 0

func _ready():
	get_node("gjapi").connect("api_authenticated", self, "on_gj_auth")
	get_node("gjapi").connect("api_user_fetched", self, "on_gj_fetch_user")
	get_node("avatar").connect("request_completed", self, "avatar_done")
	get_node("gjapi").connect("api_session_opened", self, "on_session_opened")
	get_node("gjapi").connect("api_trophy_fetched", self, "trophies_fetched")
	pass
	
func trophies_fetched(data):
	var d = {}
	d.parse_json(data)
	trophies_list = d["response"]["trophies"]
	if trophies_list.empty():
		return
	get_node("downloader").set_download_file("res://trophy_icon" + str(trophy_no) + ".jpg")
	get_node("downloader").request(trophies_list[0]["image_url"].replace("https", "http"))
	get_node("trophies").show()
	pass
	
func on_session_opened(data):
	print(data)
	pass

func _on_auth_pressed():
	get_node("gjapi").auth_user(get_node("ui/token").get_text(), get_node("ui/username").get_text())
	pass # replace with function body

func on_gj_auth(data):
	get_node("ui/open_s").set_disabled(false)
	get_node("ui/close_s").set_disabled(false)
	get_node("ui/list_trophies").set_disabled(false)
	print(data)
	get_node("gjapi").fetch_user_by_name("Rainforest")
	pass
	
func avatar_done(result, response_code, headers, body):
	var a = load("res://avatar.jpg")
	get_node("ui/container/avatar").set_texture(a)
	get_node("ui/container/my_avatar").show()
	pass
	
func on_gj_fetch_user(data):
	var res = get_node("response")
	var d = {} # declare a dictionary
	d.parse_json(data) # parse the json string
	d = d["response"]["users"][0] # the api outputs everything in one dictionary so fetch it
	for i in d.keys(): # get all information
		res.set_text(res.get_text() + "\n" + i + ": " + d[i])
	get_node("avatar").set_download_file("res://avatar.jpg")
	get_node("avatar").request(d["avatar_url"].replace("https", "http"))
	get_node("gjapi").add_score_for_guest("Whoa", 50, "TestGuest1234")
	pass

func _on_open_s_pressed():
	get_node("gjapi").open_session()
	pass # replace with function body


func _on_close_s_pressed():
	get_node("gjapi").close_session()
	pass # replace with function body


func _on_list_trophies_pressed():
	get_node("gjapi").fetch_trophies()
	pass # replace with function body


func _on_downloader_request_completed(result, response_code, headers, body):
	var i = load("res://trophy_icon" + str(trophy_no) + ".jpg")
	get_node("trophies").add_item(trophies_list[trophy_no]["title"] + " - " + trophies_list[trophy_no]["description"], i)
	trophy_no += 1
	if trophy_no >= trophies_list.size():
		return
	get_node("downloader").set_download_file("res://trophy_icon" + str(trophy_no) + ".jpg")
	get_node("downloader").request(trophies_list[trophy_no]["image_url"].replace("https", "http"))
	pass # replace with function body
