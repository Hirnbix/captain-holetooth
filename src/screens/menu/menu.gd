
extends Control

# member variables here, example:
# var a=2

var current_locale = TranslationServer.get_locale()

func _ready():

	get_node("menu_buttons/startbutton").set_text(tr("KEY_START"))
	get_node("menu_buttons/optionsbutton").set_text(tr("KEY_OPTIONS"))
	get_node("options_screen/settings").set_tab_title(0, tr("KEY_GENERAL_INFO"))
	get_node("options_screen/settings").set_tab_title(1, tr("KEY_DEBUG"))
	get_node("options_screen/settings").set_tab_title(2, tr("KEY_CREDITS"))
	
	if current_locale == "de_DE":
		var tex_de = ResourceLoader.load("res://src/screens/menu/scn1_menu_gametitle_DE.tex")
		get_node("gametitle").set_texture(tex_de)
	
	if current_locale == "en_GB":
		var tex_en = ResourceLoader.load("res://src/screens/menu/scn1_menu_gametitle_EN.tex")
		get_node("gametitle").set_texture(tex_en)

	
func _on_jump_scn3_pressed():
	transition.fade_to("res://src/levels/forest/forest.tscn")

func _on_jump_scn4_pressed():
	transition.fade_to("res://src/levels/mountain/mountain.tscn")

func _on_jump_scn5_pressed():
	transition.fade_to("res://src/levels/flyhome/flyhome.tscn")

func _on_jump_minigame_pressed():
	print("Going to minigame")
	transition.fade_to("res://src/levels/yan-kandy-minigame/prototype.tscn")

func _on_startbutton_pressed():
	transition.fade_to("res://src/screens/intro/intro.tscn")

func _on_optionsbutton_pressed():
	get_node("options_screen").show()

func _on_exitbutton_pressed():
	get_node("options_screen").hide()

func _on_de_button_pressed():
	TranslationServer.set_locale("de_DE")
	get_tree().reload_current_scene()

func _on_en_button_pressed():
	TranslationServer.set_locale("en_GB")
	get_tree().reload_current_scene()

func _on_btn_close_options_pressed():
	get_node("options_screen").hide()
