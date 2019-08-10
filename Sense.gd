# SENSOR MANAGER
# These are functions to make a ship sense it's own environment

extends Node

# GET NODES
onready var host = get_parent()
onready var world = get_node('../../../world')

# CONFIG
export var SENSE_FUTURE_T = 5 # Multiplier for velocity to get own future position in T steps

##################################################
# SENSORS

# Returns own posision in T steps as Vector2
func futurePos():
	var futurePos = host.position + (host.velocity * SENSE_FUTURE_T)
	return futurePos

# Returns all other ships as array
func otherShips():
	var ships = []
	var allShips = world.ships
	for s in allShips:
		if s.id != host.id:
			ships.append(s)
	return ships

# Returns ships where a collision would happen in T steps as array
func shipCollisions(_otherShips :Array):
	var collisions = []
	for s in host.otherShips:
		if host.futurePos.distance_to(s.futurePos) <= s.r:
			collisions.append(s)
	return collisions





