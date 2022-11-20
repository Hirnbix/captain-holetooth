
extends Sprite

# Member variables
const MODE_DIRECT = 0
const MODE_CONSTANT = 1
const MODE_SMOOTH = 2

const ROTATION_SPEED = 1
const SMOOTH_SPEED = 2.0

var mode = MODE_DIRECT


func _process(delta):
	var mpos = get_viewport().get_mouse_pos()
	
	if (mode == MODE_DIRECT):
		look_at(mpos)

		var ang = get_angle_to(mpos)
		var s = sign(ang)
		ang = abs(ang)
		
		rotate(min(ang, ROTATION_SPEED*delta)*s)



func _ready():
	set_process(true)
