extends Control

func _ready():
	pass
	
func active():
	get_node("AnimationPlayer").play("active")
	pass
	
func start():
	get_node("AnimationPlayer").play("fadein")
	pass
	
func end():
	get_node("AnimationPlayer").play("fadeout")
	pass