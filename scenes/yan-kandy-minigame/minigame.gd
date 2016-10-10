extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func reset_globals():
	globals.score_pins = 0
	globals.score_pocket = 0
	globals.score_multiplier = 1
	globals.score_total = 0

func _input(event):
	if Input.is_action_pressed("ui_select"):
		reset_globals()
		get_tree().reload_current_scene()

func _ready():
	set_process_input(true)
	# Called every time the node is added to the scene.
	# Initialization here
	pass



