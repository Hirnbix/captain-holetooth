extends TextureFrame

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var animations = get_node("animation")

func _ready():
		if global.characters_met.has("Yan"):
			animations.play("yan_unlock_anim")
		else:
			print("yan not found")