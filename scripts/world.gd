extends Node2D

onready var spawn = get_node("Spawn") # Spawn instances

# CONFIG
var SHIP_COUNT = 10

# GLOBAL VARS
var ships = []
var walls = []

func _ready():
	spawn.initWalls()
	spawn.addShipAtLeftSide()