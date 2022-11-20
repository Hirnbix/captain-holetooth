extends Node2D

func _process(delta):
	get_node("scoring/scoring_container/score_panel/score_digit").set_text(str(global.yankandy_score_total))
	get_node("scoring/scoring_container/multiplier_panel/multiplier_digit").set_text(str(global.yankandy_score_multiplier))

func reset_globals():
	global.yankandy_score_pins = 0
	global.yankandy_score_pocket = 0
	global.yankandy_score_multiplier = 1
	global.yankandy_score_total = 0

func _input(event):
	if Input.is_action_pressed("ui_select"):
		reset_globals()
		get_tree().reload_current_scene()

func _ready():
	set_process_input(true)
	set_process(true)
	# Called every time the node is added to the scene.
	# Initialization here
	pass



