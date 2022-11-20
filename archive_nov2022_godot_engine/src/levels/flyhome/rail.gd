extends Node2D

# Member variables
const SPEED = 50 #Scrolling speed
var offset = 0

# Start
func _ready():
	set_process(true)

# Process - Move the screen (player and camera)
func _process(delta):
	offset += delta * SPEED
	set_pos(Vector2(offset, 0))