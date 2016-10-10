
extends Area2D

# member variables here, example:
# var a=2
# var b="textvarfuny "

func _on_Area2D_body_enter( body ):
	print("Collided with player")
	transition.fade_to("res://scenes/scn6-castle/scn6-1.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
