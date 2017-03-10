extends Area2D

##################
# YAN
##################

onready var talkbox = get_node("yan_talkbox")

signal met_yan

func _ready():
	set_process_input(true)

# Use "shoot" to advance dialog.
# Note: Game is for kids, so no complex stuff here. Shooting is good enough for now

func _input(e):
	if e.is_action_pressed("shoot") or e.is_action_pressed("Return"):
		print("Dialog continue pressed")
		talkbox.next_line()

# Enter Yans area

func _on_Yan_body_enter( body ):
	if body.get_name() == "player":
		print("ENTER Yans dialogue")
		#get_node("yan_talkbox").show()
		talkbox.show()
		print(global.characters_met)
		talkbox.run_dialog(talkbox.dialog_yan)
		#print(dialog_yan)

# EXIT Yans area

func _on_Yan_body_exit( body ):
	if body.get_name() == "player":
		print("EXIT Yans dialogue") #Debug
		talkbox.hide() #Hide the talkbix
	if global.characters_met.has("Yan"): #Check if Yan already met
		print("Yan already met") #Debug
		talkbox.hide()
	else:
		global.characters_met.append("Yan") # Add Yan to array of met characters
		emit_signal("met_yan") # Notify HUD and play animation
		
