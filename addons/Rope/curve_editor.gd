tool
extends Node2D

var plugin

func _draw():
	set_transform(get_viewport().get_global_canvas_transform().affine_inverse())
	plugin.forward_draw_over_canvas(get_viewport().get_global_canvas_transform(), self)
