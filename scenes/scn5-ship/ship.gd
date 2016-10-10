extends Area2D

# Member variables
const MAX_SPEED = 250
const ACCELERATION = 550

onready var anim = get_node("anim")

var screen_size
var prev_shooting = false
var killed = false
var speed = Vector2(0, 0)

# animated from anim when hited
var motion_factor = Vector2(1, 1) # multiplies base motion
var root_motion = Vector2(0, 0) # applyed to base motion

const coin_type = preload("res://scenes/props/coin.gd")

func _process(delta):
	var motion = Vector2()
	if Input.is_action_pressed("move_up"):
		motion += Vector2(0, -1)
	if Input.is_action_pressed("move_down"):
		motion += Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		motion += Vector2(-1, 0)
	if Input.is_action_pressed("move_right"):
		motion += Vector2(1, 0)
	var shooting = Input.is_action_pressed("shoot")
	
	if motion.x || motion.y:
		speed += ACCELERATION * motion.normalized() * delta
	elif speed.x || speed.y:
		speed -= speed.normalized() * ACCELERATION * delta
		
	if speed.length() > MAX_SPEED:
		speed = speed.normalized() * MAX_SPEED
	
	
	var pos = get_pos()
	pos += delta*(speed*motion_factor + root_motion)
	pos.x = clamp(pos.x, 0, screen_size.x)
	pos.y = clamp(pos.y, 0, screen_size.y)
	set_pos(pos)
	
	if (shooting and not prev_shooting):
		# Just pressed
		var shot = preload("res://scenes/scn5-ship/shot.tscn").instance()
		# Use the Position2D as reference
		shot.set_pos(get_node("shootfrom").get_global_pos())
		# Put it two parents above, so it is not moved by us
		get_node("../..").add_child(shot)
		# Play sound
		get_node("sfx").play("shoot")
	
	prev_shooting = shooting


func _ready():
	screen_size = get_viewport().get_rect().size
	print(screen_size)
	set_process(true)

func _on_collision( other ):
	if !(other extends coin_type):
		anim.play("hit")
		yield(anim, "finished")
		anim.play("flying")

