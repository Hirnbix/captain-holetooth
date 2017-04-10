extends VBoxContainer

var i = 0
var card_position_offset = 80
var number_of_cards = global.characters_met.size()
var character_cards = preload("res://src/objects/character_cards/character_card.tscn")

func _ready():
	var cc_default_pos = get_node("character_card_default_placement").get_global_pos()
	print(number_of_cards)
	#character_cards_instance.set_global_pos(cc_default_pos)
	
	while i < number_of_cards:
		print(i)
		var character_cards_instance = character_cards.instance()
		var character_card_name = global.characters_met[i]
		add_child(character_cards_instance)
		i += 1
		if i == 1:
			character_cards_instance.set_global_pos(cc_default_pos)
		else:
			character_cards_instance.set_global_pos(Vector2(i * cc_default_pos.x + i*50, cc_default_pos.y))
			character_cards_instance.get_node("character_card_debug_label").set_text(character_card_name)
			print("Added instance number: " + str(i) + " - named: "+ character_card_name)
