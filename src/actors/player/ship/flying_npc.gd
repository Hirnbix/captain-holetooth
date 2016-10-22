extends Area2D

export var SPEED = 120
export var Y_RANDOM = 10
export (String, "linear", "zigzag") var motion = "linear"
export (String, "none", "explode") var destroy_sound = "explode"
export var reset_bonus = true

var destroyed = false
var speed = Vector2()
var extra_motion = Vector2()

const ship_type = preload("res://src/actors/player/ship/ship.gd")



func _ready():
	speed = Vector2(SPEED, rand_range(-Y_RANDOM, Y_RANDOM))

func _process(delta):
	translate((speed+extra_motion)*delta)


func destroy(other):
	if (destroyed):
		return
	destroyed = true
	
	if reset_bonus && other extends ship_type:
		game.reset_bonus_score()
	if destroy_sound != "none":
		get_node("sfx").play("cork_pop")
	set_process(false)
	var anim = get_node("anim")
	anim.play("explode")
	yield(anim, "finished")
	queue_free()

func _on_visibility_enter_screen():
	set_process(true)
	if motion != "linear":
		get_node("anim").play(motion)
	
	if is_monitorable() && is_monitoring_enabled():
		return
	
	yield(game.timer(0.5), "timeout")
	set_enable_monitoring(true)
	set_monitorable(true)


func _on_visibility_exit_screen():
	queue_free()
