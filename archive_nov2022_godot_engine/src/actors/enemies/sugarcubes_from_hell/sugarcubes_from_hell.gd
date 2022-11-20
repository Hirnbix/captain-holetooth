extends "res://src/actors/player/ship/flying_npc.gd"
# Shoot interval
export var shoot_interval = 1.2

# Reward for shooting it
onready var REWARD = preload("res://src/objects/rewards/reward.tscn")

# Health
export var health = 2

# Damage taken
var damage = 0

# When this enemy is seen on the screen
func _on_visibility_enter_screen():
	# Call method on flying_npc.gd
	._on_visibility_enter_screen()
	
	# Start a shoot timer
	var timer = Timer.new()
	timer.set_wait_time(shoot_interval)
	timer.set_one_shot(false)
	timer.connect("timeout", self, "shoot") # This prevents the enemy from shooting immediately when it has entered the screen
	add_child(timer)
	timer.start()


# Fire a shot!
func shoot():
	if(!destroyed && is_inside_tree()):
		# Instance a shot
		var shot = preload("res://src/actors/enemies/bullets/enemy_shot.tscn").instance()
		
		# Add it to parent, so it has world coordinates
		get_parent().add_child(shot)
		
		# Set pos as "shoot_from" Position2D node
		shot.set_global_pos( get_node("shoot_from").get_global_pos() )

func _on_sugarcube_area_enter( area ):
	var groups = area.get_groups()
	
	# If we got hit by a player shot X number of times, spawn candy! Woo!
	if(groups.has("player_shot")):
		damage += 1
		if(damage > health):
			# Spawn reward (random number between 1 and 3)
			randomize()
			spawn_reward(int(rand_range(1,4)))
			
			# Destroy self
			.destroy(area)

# Spawn X reward candies!
func spawn_reward(count):
	for i in range(0, count):
		# Create new reward
		var reward = REWARD.instance()
		
		# Generate random spawn pos
		var rnd_x = rand_range(-20,20)
		var rnd_y = rand_range(-20,20) 
		
		# Set spawn pos
		reward.set_pos(Vector2(get_pos().x + i*rnd_x, get_pos().y + i*rnd_y))
		
		# Add to scene
		get_parent().add_child(reward)