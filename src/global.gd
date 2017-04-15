extends Node

###########
# GLOBALS #
###########

# Audio Data
# Exampel of use: global.music.volume = 0.5 # Stores the music volume globally to 50%
# You will have to make the actual changes in their appropriate scripts
export var debug_mode = 1 # 1 for debug and 0 for release mode

var music = {
	volume = 0, # <0, 1> TODO: Set back to 1 when we are compiling for release. Turned it OFF to prevent going insane!
	enabled = true,
}

#####################
# Parental Controls #
#####################

var time_elapsed = 0

var playtime_limit_minutes = 15
var playtime_limit_seconds = playtime_limit_minutes * 60

##################
# Fun Statistics #
##################

var times_jumped = 0
var bubbles_popped = 0

###################
# HUD and scoring #
###################

const MAX_ITEMS = 120
var score = 0
var final_score = 0
var high_score = 0
var items_collected = 0

# Scoring Minigame yankandy
var yankandy_score_pins = 0
var yankandy_score_pocket = 0
var yankandy_score_multiplier = 1
var yankandy_score_total = 0

# Scene related
var currentScene = null

# Check if player has visited a scene already and store the last position on leaving/spawning
var last_pos = [Vector2(0,0),Vector2(0,0),Vector2(0,0)]

# Array for characters the player has met (to display the character cards in the options later)
# Captain Holetooth is in there by default
var characters_met = ["Captain Holetooth"]

######################################
#  Dictionary Character descriptions #
######################################

#not yet sure where they belong, maybe better: Dictionary for characters with name, desc etc.

##################
# Items          #
##################

var kills = false
const SCORE_MULTIPLIER = 10 # Standard Score multiplier
const SCORE_MULTIPLIER_KILLS = 5 # Player gets penalty

##################
# Inventory      #
##################

var player_inventory = [] # For now only one item will be stored here, but its good to have it no? :D

func manage_inv(inv_action, inv_item):
	if inv_action == "pickup":
		global.player_inventory.append(inv_item)
		print(str(inv_item) + " added to inventory")
		
	elif inv_action == "drop":
		global.player_inventory.erase(inv_item)
		print(str(inv_item) + " removed from inventory")

##################
# Database       #
##################

func _ready():
	score = database.get_key("score", 0)

func add_score(value=1):
	score += value
	database.set_key("score", score)