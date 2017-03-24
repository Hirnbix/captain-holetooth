
extends Node2D

signal taken

onready var anim = get_node("anim")

func _ready():
	# randomize items texture and animation
	var sprite = get_node("sprite")
	var tex_num = randi()%11+1
	var seek = randi()%4+1
	var tex_name = ("res://src/objects/rewards/" + str(tex_num) + ".png")
	var tex = load(tex_name)
	anim.seek(seek, false)
	sprite.set_texture(tex)

func take():
	get_node("sfx").play("item_pickup")
	anim.play("taken")
	yield(anim, "finished")
	emit_signal("taken")
	queue_free()