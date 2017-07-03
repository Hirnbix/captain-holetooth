extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var actor_node = get_node("../Yan/Sprite")

func _ready():
	print(actor_node.get_item_rect(Texture))
