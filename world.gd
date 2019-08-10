extends Node2D

# LOAD
var scn_ship = preload("res://ship.tscn")

# CONFIG
export var SHIP_COUNT = 10

# GLOBAL VARS
var ships = []

func _ready():
	initShips()

func initShips():
	for i in range (SHIP_COUNT):
		var ship = scn_ship.instance()
		add_child(ship)
		ship.id = i
		ships.append(ship)

func test():
	print("TEST ==> world up yo")