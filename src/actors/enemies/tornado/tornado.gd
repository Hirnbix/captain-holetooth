extends "res://src/actors/player/ship/flying_npc.gd"

const REWARD = preload("res://src/objects/rewards/reward.tscn")
const shot_type = preload("res://src/actors/player/ship/shot.gd")

func destroy(other):
	if destroyed:
		return
	if other extends shot_type:
		var reward = REWARD.instance()
		reward.set_name(get_name() + "_reward")
		reward.set_pos(get_pos())
		get_parent().add_child(reward)
	.destroy(other)


