extends "res://src/actors/player/ship/flying_npc.gd"

export var shoot_interval = 1.2

func _on_visibility_enter_screen():
	._on_visibility_enter_screen()
	var timer = Timer.new()
	timer.set_wait_time(shoot_interval)
	timer.set_one_shot(false)
	add_child(timer)
	timer.start()
	while !destroyed && is_inside_tree():
		# Instance a shot
		var shot = preload("res://src/actors/enemies/bullets/enemy_shot.tscn").instance()
		# Add it to parent, so it has world coordinates
		get_parent().add_child(shot)
		# Set pos as "shoot_from" Position2D node
		shot.set_global_pos(get_node("shoot_from").get_global_pos())
		yield(timer, "timeout")