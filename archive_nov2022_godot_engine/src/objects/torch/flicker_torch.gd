
extends Sprite

# member variables here, example:
# var a=2
# var b="textvar"

var time = 0
var timeout = rand_range(1,5)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	#find_node("SamplePlayer2D").play("torchfire")
 
func _process(delta):
	if time >= timeout:
		_timeout()
	else:
		time += 1
 
func _timeout():
	time = 0
	timeout = rand_range(1,2)
	var rndscalex = rand_range(1,1.3)

	#print(rndscalex + " " + rndscaley)
	self.set_scale(Vector2(rndscalex, rndscalex))
	



