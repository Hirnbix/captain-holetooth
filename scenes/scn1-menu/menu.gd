
extends Control

# member variables here, example:
# var a=2

func _ready():

	get_node("menu_buttons/startbutton").set_text(tr("KEY_START"))
	get_node("menu_buttons/optionsbutton").set_text(tr("KEY_OPTIONS"))
	get_node("options_screen/settings/General").set_tab_title(tr("KEY_GENERAL_INFO"))
	get_node("options_screen/settings/Debug").set_tab_title(tr("KEY_DEBUG"))
	
#	if current_locale == "de_DE":
	var tex_de = ResourceLoader.load("res://scenes/scn1-menu/scn1_menu_gametitle_DE.tex")
	get_node("gametitle").set_texture(tex_de)
	
#	if current_locale == "en_GB":
#		var tex_en = ResourceLoader.load("res://scenes/scn1-menu/scn1_menu_gametitle_EN.tex")
#		get_node("gametitle").set_texture(tex_en)

	
func _on_jump_scn3_pressed():
	print("Going to scn3")
	transition.fade_to("res://scenes/scn3-forest/scn3.tscn")

func _on_jump_scn4_pressed():
	print("Going to scn4")
	transition.fade_to("res://scenes/scn4-mountain/scn4.tscn")

func _on_jump_scn5_pressed():
	print("Going to scn5")
	transition.fade_to("res://scenes/scn5-ship/scn5.tscn")

func _on_jump_minigame_pressed():
	print("Going to minigame")
	transition.fade_to("res://scenes/yan-kandy-minigame/prototype.tscn")

func _on_startbutton_pressed():
	transition.fade_to("res://scenes/scn2-comic-intro/scn2.tscn")

func _on_optionsbutton_pressed():
	get_node("options_screen").show()

func _on_exitbutton_pressed():
	get_tree().quit()

func _on_de_button_pressed():
	TranslationServer.set_locale("de_DE")
	get_tree().reload_current_scene()

func _on_en_button_pressed():
	TranslationServer.set_locale("en_GB")
	get_tree().reload_current_scene()

func _on_btn_close_options_pressed():
	get_node("options_screen").hide()
