
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
################
# START BUTTON #
################

func _on_startbutton_pressed():
	transition.fade_to("res://scenes/scn2-comic-intro/scn2.tscn")
	pass # replace with function body

func _on_optionsbutton_pressed():
	get_node("/root/scn1-splashscreen/options_info_screen").show()


# LOCALIZATION BUTTONS

func _on_de_button_pressed():
	print("DE")
	TranslationServer.set_locale("de")
	get_tree().reload_current_scene()
	
func _on_en_button_pressed():
	TranslationServer.set_locale("en")
	print("EN")
	get_tree().reload_current_scene()	

# Exit

func _on_exitbutton_pressed():
	get_tree().quit()
	print("Exit!")





func _on_btn_close_options_pressed():
	get_node("/root/scn1-splashscreen/options_info_screen").hide()
