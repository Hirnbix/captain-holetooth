
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"

var released = false
var speed = 3
var ballpos = ""

func _fixed_process(delta):
	
	randomize()
	var random_friction = randf()*0.3+0.05
	var random_bounce = randf()*0.8+0.09

	self.set_friction(random_friction)
	self.set_bounce(random_bounce)
	
	var direction = Vector2(0,0)
	
	if released == false:
	
		if Input.is_action_pressed("ui_left"):
			print(direction)
			direction += speed * Vector2(-1,0)

		if Input.is_action_pressed("ui_right"):
			print(direction)
			direction += speed * Vector2(1,0)
	
	if Input.is_action_pressed("ui_down") and released == false:
			print("Release!")
			released = true
			set_mass(95)
			set_gravity_scale(0.8)
			direction += Vector2(0,0.01)
	
	var variance = Vector2(0, 350)
	var ballpos = self.get_pos()
	if ballpos > self.get_pos():
		get_node("Camera2D").set_pos(ballpos + variance)
	
	self.set_pos(ballpos + direction)
func _ready():
	set_fixed_process(true)
	set_mass(1)
	set_gravity_scale(0)
	pass


