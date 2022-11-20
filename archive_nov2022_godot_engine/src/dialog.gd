extends Patch9Frame # If you're using a different node than this, replace the name with the
# corresponding node you're attaching the script to.

# SOLOGUE - a small dialog system, by some nerd called ArcOfDream.
# Version 0.5
# Make sure the font is saved as a resource file when you set it up for loading.
#
# This code is distributed under the MIT license, because it's cool.
# 
# Dialogue format:
# The dialogue is passed as an array on start, then the element can be passed either
# as an array - [name_tag, font_size, dialogue_stuff] - or as a string.
# You can skip out on the font size, btw.
#
# Modifier flags:
# /dxxx - Set delay. For example if the flag is set as /d200, the delay will be 2 seconds. Must be exactly that length!
# /s - Applies a shake effect.
# /w - Now do a wave.
# /b - Text so excited it bounces.
# /r - Resets modifiers.
# Note: Setting a new modifier on a different position will override the old flags,
# So make sure that there's a combo of them on the new position.
#
# A bucket list of things to do:
# TODO: Apply portrait.
# TODO: Complete string cutting for splitting the dialogue if it's too long.
# FIXME: Proper spacing for differing font sizes
# FIXME: Make the name tag not get affected by the font size.

##################
#  Dialogs                    #
##################

var dialog_yan = [
"OH CAPTAIN",
"DIDN'T EXPECT/d020.../d005/bYOU /rHERE.",
"I'M COLLECTING MUSHROOMS.",
"I HEARD A CRASH NOISE.",
"GO /s< LEFT /rHERE.",
"YOU WILL FIND THE MOUNTAIN.",
"GOOD LUCK."]

var dialog_rootninja = [
"Uh oh... i found this thing down here...",
"Yes. Well... That's the wing I was looking for!",
"Good. Uh. Good. Go. Now. Busy digging.",
"Sure, bye Rootninja!" ]


const DEFAULT_FONT_SIZE = 45
const DEFAULT_DELAY     = 0.05
const TEXT_DELAY        = 1
const TEXT_SHAKE        = 2
const TEXT_WAVE         = 4
const TEXT_BOUNCE       = 8
const TEXT_RESET        = 0

var font           = preload("res://src/fonts/dialog-berry8.tres") # The font to be used for drawing text
var font_size      = DEFAULT_FONT_SIZE
var portrait       # Texture for the portrait.
var color          = Color(0,0,0) # Color for the text.
var input_dialog   = [] # This is the variable you want to replace for processing dialogues.
var current_string = "" # This should hold the string to iterate over.
var tag            = "" # This string is intended for the name tag.
var mods           = [] # Array for triggering text effects. Should be set roughly the same size as the length of the string.
var active_mods    = 0 # used for bitwise operations.
var progress       = -1 # value to denote progress of the dialog array.
var char_pos       = 0 # The amount of characters to process for the _draw function. Gives a typewriter effect.
var text_offset    = Vector2(15,44) # Spacing for the text draw.
var char_amt       = 0 # Amount of characters allowed in a line.
var line_amt       = 0 # Amount of lines allowed in the box.
var cutoff         = 0 # Maximum amount of allowed characters before breaking the text.
var delay          = DEFAULT_DELAY # Amount of time before adding to char_pos.
var time           = 0.0 # General time counter.
var counter        = 0.0 # Delay counter.
var visible        = true # Flag for toggling text visibility.
var continuous     = true # Updates continuously. Consider turning this on for the effects.
var running        = true # Flag for toggling the text processing. Think of it as a pause toggle.
var cut            = false # The flag to tell if to cut the line.
var line_done      = true # The final status of the string iteration.
var finished       = true # A flag set when the dialog is finished in general.
var has_tag        = false # For adding space for the tag above

#//////////////////////////////
#// Signals
#//////////////////////////////

signal dialog_start 
signal dialog_continue
signal dialog_end

#//////////////////////////////
#// Portraits, get texture
#//////////////////////////////

func _ready():
	for actor in get_tree().get_nodes_in_group("actors"):
		var actor_node_path = actor.get_path()
		print(actor_node_path)
		var actor_node = get_node(actor_node_path)

	# TODO: Figure out a better way to manage character spacing.
	char_amt = 255
	line_amt = 5
	print(char_amt, " ", line_amt)
	print(dialog_yan)
	set_fixed_process(true)
	
	# Temporary junk
#	set_process_unhandled_key_input(true) # temporary
#	run_dialog(temp_diag)


func _unhandled_key_input(key_event):
	next_line()


func _draw():
	# This will handle the text drawn on the screen.
	# The idea is that it iterates the current string until it hits the current position, 
	# which updates with the given delay.
	if visible:
		var place = 0
		var character
		var origin = 0
		var pos = Vector2(12, 12)
		var size
		
		active_mods = 0 # Let's reset this so the whole string won't go nuts.
		
		if has_tag:
			draw_string(font, text_offset,"[" + tag + "]:", color)
		
		while place < char_pos:
			# Here we have a loop which will determine position the characters will be drawn
			# up to the last available character, which is char_pos.
			character = current_string.substr(place, 1) # Gets character from current place
			origin = char_amt * floor(place/char_amt) # Calculates starting character point of a line
			size = font.get_string_size(current_string.substr(origin, place % char_amt)) # Uses the origin point and character place to determine position of character
			pos.x = text_offset.x + size.x # Apply X position
			pos.y = text_offset.y + (size.y * floor(place/char_amt + int(has_tag))) # Apply Y position
			
			if typeof(mods[place]) == TYPE_ARRAY:
				active_mods = mods[place][0]
			
			if active_mods == 0 or active_mods == TEXT_DELAY:
				# De facto action for no modifiers. We don't need the checks below, so we can proceed
				# with the next loop.
				draw_string(font, pos, character, color)
				place += 1
				continue
			
			if active_mods & TEXT_SHAKE:
				var num = 0.7
				pos += Vector2(rand_range(-num, num), rand_range(-num, num))
			if active_mods & TEXT_WAVE:
				pos.y += 2 * sin((time*5) + (place*0.4))
			if active_mods & TEXT_BOUNCE:
				pos.y += abs(4 * sin((time*5) + (place*0.5))) - 4
			draw_string(font, pos, character, color)
			place += 1


func _fixed_process(delta):
	# The process function here should be handling time before adding to the position var.
	# TODO: Implement difference between text being cut and text being done.
	
	if running and !finished and !line_done:
		if counter >= delay:
			if char_pos < current_string.length():
				# Modifier specific for delay will be put here.
				if typeof(mods[char_pos]) == TYPE_ARRAY:
					if mods[char_pos][0] & TEXT_DELAY:
						delay = mods[char_pos][1]
				
				char_pos += 1
			else:
				line_done = true
			# 
			if !continuous:
				update()
			counter = 0
		counter += delta
	
	time += delta
	
	if continuous:
		update()


func run_dialog(dialog):
	# The function to call if you want to start up a dialogue on this system.
	if typeof(dialog) == TYPE_ARRAY and finished:
		input_dialog = dialog
		finished = false
		time = 0.0
		emit_signal("dialog_start")
		next_line()


func next_line():
	# The function that  calls for the next item in the array, and processes the text accordingly.
	if line_done and !finished:
		progress += 1
		
		if progress < input_dialog.size():
			var item = input_dialog[progress] # get new variable from array
			char_pos = 2 # reset character position
			mods.clear()
			
			if typeof(item) == TYPE_ARRAY: 
				has_tag = true
				tag = item[0] # name
				if typeof(item[1]) == TYPE_INT: # optional font size here
					font_size = item[1]
					font.set_size(font_size)
					current_string = process_text(item[2])
				else: # default size if none
					font_size = DEFAULT_FONT_SIZE
					#font.set_size(DEFAULT_FONT_SIZE)
					current_string = process_text(item[1])
			else:
				# we will assume that the item is a string if it's not an array
				has_tag = false
				font_size = DEFAULT_FONT_SIZE
				delay = DEFAULT_DELAY
				current_string = process_text(item)
				# Below is a little extra that uses a ternary operator. I think it should work!
#				current_string = process_text(item) if typeof(item) == TYPE_STRING else process_text(str(item))
			
			line_done = false
			emit_signal("dialog_continue")
		
		elif progress == input_dialog.size():
			char_pos = 0
			current_string = ""
			tag = ""
			input_dialog.clear()
			mods.clear()
			has_tag = false
			finished = true
			progress = -1
			update()
			emit_signal("dialog_end")
			print("Dialogue finished!")


func process_text(string):
	# Takes a string and removes modifier flags present. Returns the processed string.
	# Modifiers are placed inside an array which will tell on which place of the string to trigger the modifiers.
	
	var i = 0
	var mod_count = 0
	var new_string = string
	mods.resize(new_string.length()) # Make array the size of the string length. Doesn't matter if it ends up being longer.
	
	while i != -1:
		mod_count = 0
		i = new_string.find("/", i) # Look for the mod flag. Returns -1 if it's not found, thus ending the loop.
		
		if i != -1:
			# First let's check if the mods array has something set for this position. 
			if typeof(mods[i]) != TYPE_ARRAY:
				mods[i] = [0, 0] # And set something for that if it's empty.
			# Now we will check for what kind of modifier is it, and add values if there's a match.
			if new_string.substr(i + 1, 1) == "d":
				mods[i][0] += TEXT_DELAY
				mods[i][1] = float(new_string.substr(i + 2, 3)) / 100
				mod_count += 4
			elif new_string.substr(i + 1, 1) == "s":
				mods[i][0] += TEXT_SHAKE
				mod_count += 1
			elif new_string.substr(i + 1, 1) == "w":
				mods[i][0] += TEXT_WAVE
				mod_count += 1
			elif new_string.substr(i + 1, 1) == "b":
				mods[i][0] += TEXT_BOUNCE
				mod_count += 1
			elif new_string.substr(i + 1, 1) == "r":
				mods[i][0] = TEXT_RESET # This is specific, in that it removes any mods afterwards.
				mod_count += 1
			new_string.erase(i, 1+mod_count) # Remove the mod part.
	
	return new_string # Finally, our squeaky clean string is given back to us.


func set_visibility(toggle):
	if typeof(toggle) == TYPE_BOOL:
		visible = toggle
		update()