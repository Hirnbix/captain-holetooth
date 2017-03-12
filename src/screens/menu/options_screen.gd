extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var debug = find_node("Debug")
	if !global.debug_mode:
		debug.get_parent().remove_child(debug)
	pass
