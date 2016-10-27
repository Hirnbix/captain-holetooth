
extends Node

# TODO: Comment this!
func _enter_tree():
	var key = str(get_parent().get_path())
	var state = game.load_key(key)
	if state != null && state["destroyed"]:
		# This prevents stuff from getting spawned in flyhome scene!!!
		# get_parent().queue_free()
		return
	
# TODO: Comment this!
func _exit_tree():
	var key = str(get_parent().get_path())
	if get_parent().get("destroyed"):
		game.save_key(key, {"destroyed":true})
