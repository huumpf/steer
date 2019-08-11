extends Node2D

onready var world = get_parent()

# LOAD
var scn_ship = preload("res://ship.tscn")
var scn_wall = preload("res://wall.tscn")

# GLOBAL VARS
var idC = 0
var timer = null

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "addShipAtLeftSide")
	timer.set_wait_time(0.29)
	timer.start()

func initWalls():
	wallBox(Vector2(300, 0), Vector2(310, 475))
	wallBox(Vector2(300, 525), Vector2(310, 800))
	wallBox(Vector2(310, 465), Vector2(600, 475))
	wallBox(Vector2(650, 200), Vector2(660, 800))
	wallBox(Vector2(360, 200), Vector2(650, 210))
	wallBox(Vector2(310, 140), Vector2(660, 150))
	
	wall(Vector2(310, 350), Vector2(320, 370))
	wall(Vector2(320, 370), Vector2(320, 390))
	wall(Vector2(320, 390), Vector2(310, 410))
	
	wall(Vector2(530, 210), Vector2(550, 220))
	wall(Vector2(550, 220), Vector2(570, 220))
	wall(Vector2(570, 220), Vector2(590, 210))

# Random positions
func addShipAtLeftSide():
	var x = -20
	var y = randf() * get_viewport().size.y
	addShip(Vector2(x, y))

func wall(a :Vector2, b :Vector2):
	var wall = scn_wall.instance()
	wall.init(a, b)
	world.add_child(wall)
	world.walls.append(wall)

func addShip(pos: Vector2):
	var ship = scn_ship.instance()
	ship.position = pos
	world.add_child(ship)
	ship.id = idC
	idC += 1
	world.ships.append(ship)

func wallBox(a :Vector2, c :Vector2):
	var b = Vector2(c.x, a.y)
	var d = Vector2(a.x, c.y)
	wall(a, b)
	wall(b, c)
	wall(c, d)
	wall(d, a)










