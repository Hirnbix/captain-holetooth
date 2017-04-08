extends Position2D


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_checkpoint_object_body_enter( body ):
	if body.is_in_group("player"):
		print("Entered Checkpoint")
