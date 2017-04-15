extends CanvasLayer

export (NodePath) var collected_text #= get_node("hudframe/items_label/score_display")
export (NodePath) var score_text #final_score_text = get_node("hudframe/finalscore_label/final_scoredisplay")
export (NodePath) var highscore_text #= get_node("hudframe/highscore_label/highscore_display")
export (NodePath) var sound_off_button #= get_node("hudframe/sound_off")

onready var animations = get_node("animations")
onready var yan = get_parent().find_node("Yan")

func _ready():
	if yan && global.last_pos[0] == Vector2(0,0):
		yan.connect("met_yan", self,"_on_met_yan")
	set_process_input(true)
	update_scores()
	game.connect("scores_changed", self, "update_scores")
	update_sound_hud()

func _on_met_yan():
	get_node("sfx").play("card_unlock")
	animations.play("yan_unlock_anim")

func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		_on_go_to_menu_pressed()
	
# Update scores
func update_scores():
	get_node(collected_text).set_text(str(game.items_collected))
	get_node(score_text).set_text(str(game.score))
	get_node(highscore_text).set_text(str(game.high_score))

func _on_go_to_menu_pressed():
	transition.fade_to("res://src/screens/menu/menu.tscn")


# Toggles music on/off while keeping the stored volume that may have been set elsewhere
func _on_sound_off_pressed():
	# Turns off music completely, or returns it back to normal
	if(global.music.enabled):
		AudioServer.set_stream_global_volume_scale(0)
	else:
		AudioServer.set_stream_global_volume_scale(global.music.volume)
	
	# Toggle bool
	global.music.enabled = !global.music.enabled
	
	# Update sound HUD
	update_sound_hud()


# Updates sound HUD
func update_sound_hud():
	if(global.music.enabled):
		get_node(sound_off_button).set_pressed(true) # res://src/screens/hud/sound_on.png
	else:
		get_node(sound_off_button).set_pressed(false) # res://src/screens/hud/sound_off.png