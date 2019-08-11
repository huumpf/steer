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

# Returns ships where a collision would happen in T steps as array
func shipCollisions():
	var collisions = []
	for s in world.ships:
		if host.futurePos.distance_to(s.futurePos) <= s.r and s.id != host.id:
			collisions.append(s.futurePos)
	return collisions

func wallCollisions():
	var collisions = []
	for w in world.walls:
		var closest = getClosestPointToWall(w)
		var dist_v = host.futurePos - closest
		if (dist_v.length() < host.r):
			collisions.append(closest)
	return collisions

func getClosestPointToWall(wall):
	var pt_v = host.position - wall.a
	var w_unit = wall.v.normalized()
	var projLen = pt_v.dot(w_unit)
	if (projLen< 0):
		return wall.a
	if (projLen > wall.v.length()):
		return wall.b
	var projVec = w_unit * projLen
	var closest = projVec + wall.a
	return closest

