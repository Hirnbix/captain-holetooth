
extends Node

###########
# GLOBALS #
###########

# HUD and scoring

const MAX_ITEMS = 120
var score = 0
var final_score = 0
var high_score = 0
var items_collected = 0

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
	