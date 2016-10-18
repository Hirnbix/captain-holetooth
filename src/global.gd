
extends Node

###########
# GLOBALS #
###########

# Audio Data
# Exampel of use: global.music.volume = 0.5 # Stores the music volume globally to 50%
# You will have to make the actual changes in their appropriate scripts
var music = {
	volume = 0, # TODO: Set back to 1 when we are compiling for release. Turned it OFF to prevent going insane!
	enabled = true,
}

# Statistics
var times_jumped = 0

# HUD and scoring
const MAX_ITEMS = 120
var score = 0
var final_score = 0
var high_score = 0
var items_collected = 0

# Scoring Minigame
var score_pins = 0
var score_pocket = 0
var score_multiplier = 1
var score_total = 0

# Scene related
var currentScene = null

# Check if player has visited a scene already
var beentoscn3 = true 
var beentoscn4 = true
var beentoscn5 = true

# Items related
var kills = false
const SCORE_MULTIPLIER = 10 # Standard Score multiplier
const SCORE_MULTIPLIER_KILLS = 5 # Player gets penalty

func _ready():
	score = database.get_key("score", 0)
	

func add_score(value=1):
	score += value
	database.set_key("score", score)
	