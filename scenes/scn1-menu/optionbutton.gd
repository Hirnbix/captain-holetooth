
extends Button

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_optionsbutton_pressed():
	get_node("/root/scn1-splashscreen/options_info_screen").show()
	pass # replace with function body


func _on_close_button_pressed():
	get_node("/root/scn1-splashscreen/options_info_screen").hide()
	pass # replace with function body
