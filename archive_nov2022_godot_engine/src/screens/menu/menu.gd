
extends Control

# Game Title
export (NodePath) var game_title_path
onready var game_title = get_node(game_title_path)

# Menu Buttons
export (NodePath) var menu_buttons_path
onready var menu_buttons = get_node(menu_buttons_path)

# Options Screen
export (NodePath) var options_screen_path
onready var options_screen = get_node(options_screen_path)

# Music Player
export (NodePath) var music_player_path
onready var music_player = get_node(music_player_path)

# Music Volume Slider
export (NodePath) var music_volume_slider_path
onready var music_volume_slider = get_node(music_volume_slider_path)

# Animations
export (NodePath) var animations_path
onready var animations = get_node(animations_path)

# Current Language Locale
var current_locale = TranslationServer.get_locale()


# -- START --
func _ready():
	# Update music player volume the initial music volume stored in global
	music_volume_slider.set_value(global.music.volume * 100) 
	# Set playtime limit field
	get_node("options_screen/settings/Parental Controls/playtime_settings/playtime_limit").set_text(str(global.playtime_limit_minutes))
	# Updates locale on scene
	#update_locale()
	get_node("menu_buttons/startbutton").grab_focus()


# -- BUTTON PRESSES --
# Start Game
func _on_startbutton_pressed():
	transition.fade_to("res://src/screens/intro/intro.tscn")
	get_node("sfx").play("click")

# Options
func _on_optionsbutton_pressed():
	options_screen.show()
	options_screen.set_process_input(true)
	get_node("sfx").play("click")

# Exit
func _on_exitbutton_pressed():
	options_screen.hide()
	options_screen.set_process_input(false)
	get_node("menu_buttons/startbutton").grab_focus()
	get_node("sfx").play("click")
	
# Close Options
func _on_btn_close_options_pressed():
	options_screen.hide()
	get_node("sfx").play("click")

# Change Language to German
func _on_de_button_pressed():
	get_node("sfx").play("click")
	TranslationServer.set_locale("de_DE")
	get_tree().reload_current_scene()


# Change Language to English
func _on_en_button_pressed():
	get_node("sfx").play("click")
	TranslationServer.set_locale("en_GB")
	get_tree().reload_current_scene()


 #-- LOCALE / LANGUAGES --
# Updates all locale on Main Menu according to current_locale selected
#func update_locale():
#	# DISABLED FOR NOW
#	# Will add more languages when there is more time.
#			
#			
#			
#			# Update Locale Text
#		#	menu_buttons.get_node("startbutton").set_text(tr("KEY_START"))
#		#	menu_buttons.get_node("optionsbutton").set_text(tr("KEY_OPTIONS"))
#		#	options_screen.get_node("settings").set_tab_title(0, tr("KEY_GENERAL_INFO"))
#		#	options_screen.get_node("settings").set_tab_title(1, tr("KEY_AUDIO"))
#		#	options_screen.get_node("settings").set_tab_title(2, tr("KEY_DEBUG"))
#		#	options_screen.get_node("settings").set_tab_title(3, tr("KEY_CREDITS"))
#		
#			# Setup Language buttons
#			# - German
#		#	if current_locale == "de_DE":
#		#		var tex_de = ResourceLoader.load("res://src/screens/menu/scn1_menu_gametitle_EN.png")
#		#		game_title.set_texture(tex_de)
#		#
#		#	# - English
#		#	if current_locale == "en_GB":
#		#		var tex_en = ResourceLoader.load("res://src/screens/menu/scn1_menu_gametitle_EN.png")
#		#		game_title.set_texture(tex_en)
#
#
 #-- MUSIC --
 #Updates global music volume when slider has been changed

func _on_music_volume_value_changed( value ):
	# Set global music volume
	global.music.volume = value/100

	# Update music player volume
	music_player.set_volume(global.music.volume)


# -- DEBUG --
# DEBUG: Jump to scene 3
func _on_jump_scn3_pressed():
	print("Transition to Scene 3")
	transition.fade_to("res://src/levels/forest/forest.tscn")

# DEBUG: Jump to scene 4
func _on_jump_scn4_pressed():
	print("Transition to mountain")
	transition.fade_to("res://src/levels/mountain/mountain.tscn")

# DEBUG: Jump to scene 5
func _on_jump_scn5_pressed():
	print("Transition to fly home")
	transition.fade_to("res://src/levels/flyhome/flyhome.tscn")

# DEBUG: Jump to minigame
func _on_jump_minigame_pressed():
	print("Transition to minigame")
	transition.fade_to("res://src/levels/minigames/yankandy/yankandy.tscn")

func _on_jump_castle_pressed():
	print("Transition to castle")
	transition.fade_to("res://src/levels/castle/castle_outside.tscn")
	
func _on_donate_button_pressed():
	OS.shell_open("https://www.patreon.com/hirnbix")
	pass # replace with function body


func _on_playtime_confirm_pressed():
	global.playtime_limit_minutes = get_node("options_screen/settings/Parental Controls/playtime_settings/playtime_limit").get_text()
	global.playtime_limit_seconds = int(global.playtime_limit_minutes) * 60
	print(global.playtime_limit_seconds)


func _on_charactercardsbutton_pressed():
	print("Transition to character cards")
	transition.fade_to("res://src/screens/character-cards/character-cards.tscn")

func _on_candy_skull_button_pressed():
	animations.connect("finished", animations, "play", ["wigglecandy"])
