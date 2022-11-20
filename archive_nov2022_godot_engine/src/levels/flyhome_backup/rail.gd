extends Node2D

# Member variables
const SPEED = 120
var offset = 0


#func stop():
#	set_process(false)


func _process(delta):
	offset += delta*SPEED
	set_pos(Vector2(offset, 0))


func _ready():
	set_process(true)
