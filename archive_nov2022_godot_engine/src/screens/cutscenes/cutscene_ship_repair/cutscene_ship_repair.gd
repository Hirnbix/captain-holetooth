extends TextureFrame

# Level path to the scene we are switching to
var level_path = "res://src/levels/flyhome/flyhome.tscn"

func _ready():
	set_process_input(true)

func _input(event):
	if Input.is_action_pressed("ui_accept"):
		_on_skipbutton_pressed()


# Mouse click on screen to continue
func _on_skipbutton_pressed():
	transition.fade_to(level_path)

# On the completion of the animation, continue to the game
func _on_animation_player_finished():
	transition.fade_to(level_path)