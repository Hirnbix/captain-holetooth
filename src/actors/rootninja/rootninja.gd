extends Area2D

##################
# Rootninja
##################

export (NodePath) var select_dialogbox #Select the node path
onready var dialogbox = get_node(select_dialogbox)

signal met_rootninja

func _ready():
	set_process_input(true)

# Use "shoot" to advance dialog.
# Note: Game is for kids, so no complex stuff here. Shooting is good enough for now

func _input(e):
	if e.is_action_pressed("shoot"):
		print("Dialog continue pressed")
		dialogbox.next_line()

# Enter Yans area

func _on_Yan_body_enter( body ):
	if body.get_name() == "player":
		print("ENTER Yans dialogue")
		print(global.characters_met)
		dialogbox.show()
		dialogbox.run_dialog(dialogbox.dialog_rootninja)

# EXIT Yans area

func _on_Yan_body_exit( body ):
	if body.get_name() == "player":
		print("EXIT Yans dialogue") #Debug
		dialogbox.hide() #Hide the talkbix
	if global.characters_met.has("Rootninja"): #Check if Yan already met
		print("Yan already met") #Debug
		dialogbox.hide()
	else:
		global.characters_met.append("Rootninja") # Add Yan to array of met characters
		emit_signal("met_rootninja") # Notify HUD and play animation
		
