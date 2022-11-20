extends VBoxContainer

var i = 0
var number_of_cards = global.characters_met.size()
var character_cards = preload("res://src/objects/character_cards/character_card.tscn")

func _ready():
	var card_space = self.get_size()
	var card_container_position = self.get_position_in_parent()
	var left_margin = 100
	var top_margin = 140
	var innercard_margin_w = 10
	var innercard_margin_h = 10
	print(number_of_cards)
	print(card_space, card_container_position)
	#print(character_cards_size)
	#character_cards_instance.set_global_pos(cc_default_pos)
	
	while i < number_of_cards:
		print(i)
 		#var x = left_margin + ((i % 3) * (innercard_margin_w + card_width)) and y = top_margin + (floor(i / 3) * (innercard_margin_h + card_height))
		var character_cards_instance = character_cards.instance()
		var character_card_name = global.characters_met[i]
		add_child(character_cards_instance)
		var card_dimensions = character_cards_instance.get_node("character_card_button").get_size()
		var card_height = card_dimensions.y
		var card_width = card_dimensions.x
		print(str(card_width) + " " + str(card_height))
		i += 1
		character_cards_instance.set_pos(Vector2(left_margin + ((i % 3) * (innercard_margin_w + card_width)), top_margin + (floor(i / 3) * (innercard_margin_h + card_height))))
		character_cards_instance.get_node("character_card_debug_label").set_text(character_card_name)
		
		print("Added instance number: " + str(i) + " - named: "+ character_card_name + " at "+ str(character_cards_instance.get_pos()))
		