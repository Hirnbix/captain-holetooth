
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"
onready var animations = find_node("animations")
onready var talkbox = get_node("yan_talkbox")

func _ready():
	set_process_input(true)
	
func _input(e):
	if e.is_action_pressed("shoot"):
		print("Enter pressed")
		talkbox.next_line()

func _on_Yan_body_enter( body ):
	if body.get_name() == "player":
		print("ENTER Yans dialogue")
		#get_node("yan_talkbox").show()
		talkbox.show()
		print(global.characters_met)
		talkbox.run_dialog(talkbox.dialog_yan)
		#print(dialog_yan)

func _on_Yan_body_exit( body ):
	if body.get_name() == "player":
		print("EXIT Yans dialogue")
		talkbox.hide()
	if global.characters_met.has("Yan"):
		print("Yan already met")
	else:
		global.characters_met.append("Yan")
		
