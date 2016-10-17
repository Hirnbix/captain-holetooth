
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("yan_dialogue").hide()
	pass

func _on_Yan_body_enter( body ):
	if body.get_name() == "player":
		print("ENTER Yans dialogue")
		get_node("yan_dialogue").show()
		pass # replace with function body

func _on_Yan_body_exit( body ):
	if body.get_name() == "player":
		print("EXIT Yans dialogue")
		get_node("yan_dialogue").hide()
		pass # replace with function body