extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"

var touched_wood = 0

func _on_box_body_enter( body ):
	touched_wood += 1
	print("touched wood:" + str(touched_wood) + " times")
	
	if touched_wood < 9:
		get_node("sfx").play("wood_knock")
	
	else:
		get_node("/root/yankandy/ball").set_sleeping(true)

	
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass



