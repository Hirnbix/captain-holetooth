extends KinematicBody2D

# Gameplay Variables
var speed = 220  # Speed this will move
var distanceBetween = 100    # Distance between this and the player before we start moving towards

# References
var playerNode; # Player node
var plrLastPos; # Players current position (Saved for next frame)

func _ready():
	playerNode = get_node("/root/scn3/player")
	plrLastPos = playerNode.get_global_pos() # Make this not null for first frame
	set_fixed_process(true)

func _process(delta):
	var plrPos = playerNode.get_global_pos()
	print(plrPos)
	var distancePlayerMoved = plrLastPos.distance_to(plrPos) # The distance between player this and last frame

	if(get_pos().distance_to(plrPos) > distanceBetween):  # Only move if the distance between is larger than max
		var dir = (plrLastPos - plrPos).normalized()      # Get direction player moved
		var pointToMoveTo = ((plrPos + dir * distanceBetween) - get_global_pos()) # Get the point that is behind where the player is moving "distanceBetween" pixels away
		move(pointToMoveTo.normalized() * speed * delta) # Move to that point at the speed set

	plrLastPos = plrPos # Record player position this frame for next