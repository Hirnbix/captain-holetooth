extends Area2D

# Max Speed
const MAX_SPEED = 250

# Time in Seconds the speed boost lasts
const SPEED_BOOST_TIME = 2 # seconds
const SPEED_BOOST_MULTIPLIER = 1.5 # 2x speed multiplier
var speed_boost = 1 # This changes to the multipler when boost is enabled

const ACC_BOOST_TIME = 5 # seconds
const ACC_BOOST_MULTIPLIER = 7.5 # 7.5x more ship control!
var acc_boost = 1

# Acceleration
const ACCELERATION = 950 # Higher acceleration gives the player quicker control over the ship

# Animation player
export (NodePath) var anim_player_path
onready var anim_player = get_node(anim_player_path)

# Screen Size is used to determine where the player can fly
var screen_size
var prev_shooting = false
var killed = false
var speed = Vector2(0, 0)

# animated from anim when hited
var motion_factor = Vector2(1, 1) # multiplies base motion
var root_motion = Vector2(0, 0) # applyed to base motion

# Shoot delay
var shoot_delay_sec = 0.08

# Coin
const coin_type = preload("res://src/objects/rewards/reward.gd")

# Processing
func _process(delta):
	# Player motion
	var motion = Vector2()
	
	# Input: MOVE UP
	if(Input.is_action_pressed("move_up")):
		motion += Vector2(0, -1)
	# Input: MOVE DOWN
	if(Input.is_action_pressed("move_down")):
		motion += Vector2(0, 1)
	# Input: MOVE LEFT
	if(Input.is_action_pressed("move_left")):
		motion += Vector2(-1, 0)
	# Input: MOVE RIGHT
	if(Input.is_action_pressed("move_right")):
		motion += Vector2(1, 0)
	# Input: SHOOT
	# REMOVED FOR 2.1 Stable: if(Input.is_action_just_pressed("shoot")):
	if(Input.is_action_pressed("shoot") && timer.get_time_left()<=0):
		timer.start()
		# Create a new shot instance
		var shot = preload("shot.tscn").instance()
		
		# Use the Position2D as spawn coordinate for our new shot
		shot.set_pos( get_node("shootfrom").get_global_pos() )
		
		# Put it two parents above, so it is not moved by us
		get_node("../..").add_child(shot)
		
		# Play shooting sound
		get_node("sfx").play("shoot")
	
	# If we are pressing any movement keys, increase speed
	if(motion.x || motion.y):
		speed += acc_boost * ACCELERATION * motion.normalized() * delta
	
	# If we are NOT pressing any movement keys, and we have some speed, deaccelerate to a full stop
	elif(speed.x || speed.y):
		speed -= acc_boost * ACCELERATION * speed.normalized() * delta
	
	# Prevents ship speed from going faster than MAX_SPEED
	if(speed.length() > MAX_SPEED):
		speed = speed.normalized() * MAX_SPEED
	
	# Move player
	var pos = get_pos()
	
	# Celculate position to where we are moving
	pos += delta * (speed_boost * speed * motion_factor + root_motion)
	
	# Prevent ship from going outside the screen
	pos.x = clamp(pos.x, 0, screen_size.x)
	pos.y = clamp(pos.y, 0, screen_size.y)
	
	# Set new player position
	set_pos(pos)

var timer = null
# Start
func _ready():
	# Screen size is used to calculate whether or not the player is inside it
	screen_size = get_viewport().get_rect().size
	
	timer = Timer.new()
	add_child(timer)
	timer.set_one_shot(true)
	timer.set_wait_time(shoot_delay_sec)
	
	# Enable process
	set_process(true)


# SPEED BOOST
# Used by certain pickup items to give the player a speed boost
var speed_timer = null
func speed_boost():
	# If it is not already running
	if(speed_boost == 1):
		# If this is the first time running, create timer
		if(speed_timer == null):
			speed_timer = Timer.new()
			speed_timer.set_wait_time(SPEED_BOOST_TIME)
			speed_timer.set_one_shot(true)
			add_child(speed_timer)
		
		# Set speed boost
		speed_boost = SPEED_BOOST_MULTIPLIER
	
		# Start timer
		speed_timer.start()
		
		# Wait for timeout
		yield(speed_timer, "timeout")
		
		# Disable speed boost
		speed_boost = 1 # back to 1


# ACCELERATION BOOST
# Used by certain pickup items to give the player more ship control
var acc_timer = null
func acc_boost():
	# If it is not already running
	if(acc_boost == 1):
		# If this is the first time running, create timer
		if(acc_timer == null):
			acc_timer = Timer.new()
			acc_timer.set_wait_time(ACC_BOOST_TIME)
			acc_timer.set_one_shot(true)
			add_child(acc_timer)
		
		# Set speed boost
		acc_boost = ACC_BOOST_MULTIPLIER
	
		# Start timer
		acc_timer.start()
		
		# Wait for timeout
		yield(acc_timer, "timeout")
		
		# Disable speed boost
		acc_boost = 1 # back to 1

# On area enter the player
func _on_player_area_enter( area ):
	var groups = area.get_groups()
	
	if(groups.has("enemy") || groups.has("enemy_shot")):
		# Play ship 'hit' animation
		anim_player.play("hit")
		
		# Wait for the animation to complete
		yield(anim_player, "finished")
		
		# Go back to the 'flying' animation (default)
		anim_player.play("flying")