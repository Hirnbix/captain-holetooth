
extends CollisionShape2D

# member variables here, example:
# var a=2
# var b="textvar"

func _on_transition_to_scn5_body_enter( body ):
		if body.get_name() == "player":
			print("Collided with player")
			transition.fade_to("res://scenes/scn5-ship/scn5.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass