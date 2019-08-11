extends Node2D

# LOAD
var scn_ship = preload("res://ship.tscn")
var scn_wall = preload("res://wall.tscn")

# CONFIG
var SHIP_COUNT = 10

# GLOBAL VARS
var timer = null
var idC = 0
var ships = []
var walls = []

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "addShipAtLeftSide")
	timer.set_wait_time(0.15)
	timer.start()
	
	initWalls()
	addShipAtLeftSide()

###############################################################
# ADD INSTANCES

func initWalls():
	addWall(Vector2(500, 0), Vector2(500, 275))
	addWall(Vector2(500, 325), Vector2(500, 800))

# Random positions
func addShipAtLeftSide():
	var x = -20
	var y = randf() * get_viewport().size.y
	var targets = [Vector2(495, 300), Vector2(1200, 300)]
	addShip(Vector2(x, y), targets)

func addWall(a :Vector2, b :Vector2):
	var wall = scn_wall.instance()
	wall.init(a, b)
	add_child(wall)
	walls.append(wall)

func addShip(pos, targets):
	var ship = scn_ship.instance()
	ship.position = pos
	add_child(ship)
	ship.id = idC
	idC += 1
	ship.plan.targets = targets
	ships.append(ship)