extends TextureFrame

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var animations = get_node("animation")
onready var yan = get_node("/root/scn3/world/NPCs/Yan")

func _ready():
	if has_node("Yan"):
		yan.connect("met_yan",self,"_on_met_yan")
	else:
		pass
	
func _on_met_yan():
			get_node("sfx").play("card_unlock")
			animations.play("yan_unlock_anim")