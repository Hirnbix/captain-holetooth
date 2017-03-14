extends Node2D

onready var tabs = get_node("settings")


func _ready():
	var debug = find_node("Debug")
	if !global.debug_mode:
		debug.get_parent().remove_child(debug)
	

func _input(event):
	if Input.is_action_pressed("ui_left"):
		if tabs.get_current_tab()-1<0:
			tabs.set_current_tab( tabs.get_tab_count()-1 )
		else:
			tabs.set_current_tab( tabs.get_current_tab()-1 )
	elif Input.is_action_pressed("ui_right"):
		if tabs.get_current_tab()+1>=tabs.get_tab_count():
			tabs.set_current_tab( 0 )
		else:
			tabs.set_current_tab( tabs.get_current_tab()+1 )
			
	if Input.is_action_pressed("ui_cancel"):
		get_parent()._on_exitbutton_pressed()

#Workaround bug moving right from instructions makes wrong focus on buttons
func _on_settings_tab_changed( tab ):
	if tabs.get_current_tab_control().get_children().size()>0 && tabs.get_current_tab_control().get_name() == "Debug":
		tabs.get_current_tab_control().set_process(true)
