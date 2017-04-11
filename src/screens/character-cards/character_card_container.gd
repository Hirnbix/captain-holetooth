extends VBoxContainer

var i = 0
var number_of_cards = global.characters_met.size()
var character_cards = preload("res://src/objects/character_cards/character_card.tscn")

func _ready():
	var card_space = self.get_size()/3
	print(number_of_cards)
	print(card_space)
	#character_cards_instance.set_global_pos(cc_default_pos)
	
	while i < number_of_cards:
		print(i)
		var character_cards_instance = character_cards.instance()
		var character_card_name = global.characters_met[i]
		add_child(character_cards_instance)
		i += 1
		if i <= 3:
			character_cards_instance.set_global_pos(Vector2(i * card_space*0.8))
			character_cards_instance.get_node("character_card_debug_label").set_text(character_card_name)
			print("Added instance number: " + str(i) + " - named: "+ character_card_name)
		else:
			#card_space.x -= 140
			character_cards_instance.set_global_pos(Vector2(i * card_space*0.16))
			character_cards_instance.get_node("character_card_debug_label").set_text(character_card_name)
			print("Added instance number: " + str(i) + " - named: "+ character_card_name)
