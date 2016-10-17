
extends Node

# member variables here, example:
# var a=2
# var b="textvar"

func _enter_tree():
	var key = str(get_parent().get_path())
	var state = game.load_key(key)
	if state != null && state["destroyed"]:
		get_parent().queue_free()
		return
	

func _exit_tree():
	var key = str(get_parent().get_path())
	if get_parent().get("destroyed"):

		game.save_key(key, {"destroyed":true})
