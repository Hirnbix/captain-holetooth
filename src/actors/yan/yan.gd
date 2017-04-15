extends Area2D

##################
# YAN
##################

export (NodePath) var select_dialogbox #Select the node path
onready var dialogbox = get_node(select_dialogbox)

signal met_yan

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
		dialogbox.run_dialog(dialogbox.dialog_yan)

# EXIT Yans area

func _on_Yan_body_exit( body ):
	if body.get_name() == "player":
		print("EXIT Yans dialogue") #Debug
		dialogbox.hide() #Hide the talkbix
	if global.characters_met.has("Yan"): #Check if Yan already met
		print("Yan already met") #Debug
		dialogbox.hide()
	else:
		emit_signal("met_yan") # Notify HUD and play animation
		global.characters_met.append("Yan") # Add Yan to array of met characters
		
