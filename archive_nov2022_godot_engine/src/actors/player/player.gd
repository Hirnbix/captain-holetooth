
extends RigidBody2D

# Member variables
var anim = ""
var siding_left = false
var jumping = false
var shooting = false

var WALK_ACCEL = 2000.0 # Higher = Better control, Lower = Sluggish
var WALK_DEACCEL = 2000.0
var WALK_MAX_VELOCITY = 300.0
var AIR_ACCEL = 300.0 # It's over 9000! 
var AIR_DEACCEL = 2900.0 # Make it higher to give the player better air control, or slower to make the game more "realistic"
var JUMP_VELOCITY = 438
var STOP_JUMP_FORCE = 2000.0

var MAX_FLOOR_AIRBORNE_TIME = 0.15

var DIR_LEFT = Vector2(-1,1)
var DIR_RIGHT = Vector2(1,1)
var CURR_DIR = Vector2(1,1)
var LAST_DIR = Vector2(0,0)

var airborne_time = 1e20
var shoot_time = 1e20

var MAX_SHOOT_POSE_TIME = 0.3

var bullet = preload("res://src/actors/player/bullet.tscn")

var floor_h_velocity = 0.0
var enemy

#func beam_to(spawner):
	
#	var spawnerpos = get_node(spawner).get_global_pos()
#	print("Beam to active!")
#	self.set_pos(spawnerpos)


func _integrate_forces(s):
	var linear_vel = s.get_linear_velocity()
	var step = s.get_step()
	
	var new_anim = anim
	var new_siding_left = siding_left
	
	# Get the controls
	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	var shoot = Input.is_action_pressed("shoot")
	var spawn = Input.is_action_pressed("spawn")
	
	
	if spawn:
		var e = enemy.instance()
		var p = get_pos()
		p.y = p.y - 100
		e.set_pos(p)
		get_parent().add_child(e)
	
	# Deapply prev floor velocity
	linear_vel.x -= floor_h_velocity
	floor_h_velocity = 0.0
	
	# Find the floor (a contact with upwards facing collision normal)
	var found_floor = false
	var floor_index = -1
	
	for x in range(s.get_contact_count()):
		var ci = s.get_contact_local_normal(x)
		if (ci.dot(Vector2(0, -1)) > 0.6):
			found_floor = true
			floor_index = x
	
	# Calculate air born time in order to control when to stop jump
	# from the user releasing jump or reaching max jump height
	if (found_floor):
		airborne_time = 0.0
	else:
		airborne_time += step # Time it spent in the air
	
	var on_floor = airborne_time < MAX_FLOOR_AIRBORNE_TIME

	# Process jump
	if (jumping):
		if (linear_vel.y > 0):
			# Set off the jumping flag if going down
			jumping = false

		if (!jump):
			linear_vel.y += STOP_JUMP_FORCE*step
	
	if (on_floor):
		# Process logic when character is on floor
		if (move_left and not move_right):
			CURR_DIR = DIR_LEFT
			if (linear_vel.x > -WALK_MAX_VELOCITY):
				linear_vel.x -= WALK_ACCEL*step
				# Prevent player from exceeding max walk velocity
				if(linear_vel.x < -WALK_MAX_VELOCITY):
					linear_vel.x = -WALK_MAX_VELOCITY
				
		elif (move_right and not move_left):
			CURR_DIR = DIR_RIGHT
			if (linear_vel.x < WALK_MAX_VELOCITY):
				linear_vel.x += WALK_ACCEL*step
				# Prevent player from exceeding max walk velocity
				if(linear_vel.x > WALK_MAX_VELOCITY):
					linear_vel.x = WALK_MAX_VELOCITY
		else:
			var xv = abs(linear_vel.x)
			xv -= WALK_DEACCEL*step
			if (xv < 0):
				xv = 0
			linear_vel.x = sign(linear_vel.x)*xv
	
		# If we can, and want to JUMP - Jump!
		if (!jumping && jump):
			# Set velocity upwards 
			linear_vel.y = -JUMP_VELOCITY
			
			# Notify code that we are jumping
			jumping = true
			
			# Play the player's jump sound
			if !get_node("sfx").is_active():
				get_node("sfx").play("flupp")
			# THIS IS FOR FUTURE USE - Its a statistics thing for players to see like "Hey you only jumped 20 times during the whole game..."
			# Whatever use it is, i think its a fun element to talk about :D
			# I don't care often about the "use" of things... just having it for fun is good enough ;)
			global.times_jumped = global.times_jumped +1
			# print(global.times_jumped)
			
			# Achievement for jumping 50 times - Increased jump height
			if (global.times_jumped > 50):
				JUMP_VELOCITY = 550
				# print("Yay! You can now jump higher")
				# TODO: Print an achievement notification message to the player
		
		
		# Check jumping
		if (jumping):
			# Set the next animation
			new_anim = "jumping"
		
		# Handling an idle player
		elif (abs(linear_vel.x) < 0.1): # Using a 0.1 padding for when we consider the player to be idle
			if (shoot_time < MAX_SHOOT_POSE_TIME):
				new_anim = "idle_weapon"
			else:
				new_anim = "idle"
		
		# The player is moving (not jumping)
		else:
			if (shoot_time < MAX_SHOOT_POSE_TIME):
				new_anim = "run_weapon"
			else:
				new_anim = "run"
	else:
		# Process logic when the character is in the air
		# When we are only pressing LEFT movement
		if (move_left && !move_right):
			CURR_DIR = DIR_LEFT
			if (linear_vel.x > -WALK_MAX_VELOCITY):
				# linear_vel.x = -WALK_MAX_VELOCITY
				linear_vel.x -= AIR_ACCEL*step
				if(linear_vel.x < -WALK_MAX_VELOCITY):
					linear_vel.x = -WALK_MAX_VELOCITY
				
		elif (move_right && !move_left):
			CURR_DIR = DIR_RIGHT
			if (linear_vel.x < WALK_MAX_VELOCITY):
				# linear_vel.x = WALK_MAX_VELOCITY
				linear_vel.x += AIR_ACCEL*step
				if(linear_vel.x > WALK_MAX_VELOCITY):
					linear_vel.x = WALK_MAX_VELOCITY
		else:
			# Deaccelerate air movement (quickly for a smooth gameplay experience)
			var x_vel = abs(linear_vel.x)
			x_vel -= AIR_DEACCEL*step
			if (x_vel < 0):
				x_vel = 0
			linear_vel.x = sign(linear_vel.x)*x_vel
		
		if (linear_vel.y < 0):
			if (shoot_time < MAX_SHOOT_POSE_TIME):
				new_anim = "jumping_weapon"
			else:
				new_anim = "jumping"
		else:
			if (shoot_time < MAX_SHOOT_POSE_TIME):
				new_anim = "falling_weapon"
			
			else:
				new_anim = "falling"
	
	# A good idea when impementing characters of all kinds,
	# compensates for physics imprecission, as well as human reaction delay.
	if (shoot and not shooting):
		shoot_time = 0
		var bi = bullet.instance()
		var ss
		#if (CURR_DIR==DIR_LEFT):
		#	ss = -1.0
		#else:
		#	ss = 1.0
		var pos = get_pos() + get_node("bullet_shoot").get_pos()*CURR_DIR
		
		bi.set_pos(pos)
		get_parent().add_child(bi)
		
		bi.set_linear_velocity(Vector2(800.0*CURR_DIR.x, -80))
		get_node("sprite/smoke").set_emitting(true)
		get_node("sfx").play("schwuit")
		PS2D.body_add_collision_exception(bi.get_rid(), get_rid()) # Make bullet and this not collide
	else:
		shoot_time += step
	# Check siding direction
	#if (linear_vel.x < 0 && move_left):
	#	new_siding_left = true
	#elif (linear_vel.x > 0 && move_right):
	#	new_siding_left = false
		
	# Update siding
	if (LAST_DIR!=CURR_DIR):
		if (move_left):
			get_node("sprite").set_scale(DIR_LEFT)
			LAST_DIR = DIR_LEFT
		elif(move_right):
			get_node("sprite").set_scale(DIR_RIGHT)
			LAST_DIR = DIR_RIGHT
	
	# Change animation
	if (new_anim != anim):
		anim = new_anim
		get_node("anim").play(anim)
	
	shooting = shoot
	
	# Apply floor velocity
	if (found_floor):
		floor_h_velocity = s.get_contact_collider_velocity_at_pos(floor_index).x
		linear_vel.x += floor_h_velocity
	
	# Finally, apply gravity and set back the linear velocity
	linear_vel += s.get_total_gravity()*step
	s.set_linear_velocity(linear_vel)
	


func _ready():
	set_process(true)
	enemy = ResourceLoader.load("res://scenes/scn3-forest/enemy.tscn")
	# Update play time, has to go into a global function at some point
func _process(delta):
	global.time_elapsed += delta
	#print(global.time_elapsed)
	if global.time_elapsed >= int(global.playtime_limit_seconds):
		#print("Time elpased!")
		#show(Popup)
		global.time_elapsed = 0


#	if !Globals.has_singleton("Facebook"):
#		return
#	var Facebook = Globals.get_singleton("Facebook")
#	var link = Globals.get("facebook/link")
#	var icon = Globals.get("facebook/icon")
#	var msg = "I just sneezed on your wall! Beat my score and Stop the Running nose!"
#	var title = "I just sneezed on your wall!"
#	Facebook.post("feed", msg, title, link, icon)
