extends Node2D

onready var host = get_parent()
var targets = []
var mainTarget = Vector2()

func _ready():
	var r = randi()%2+1
	if r == 1:
		mainTarget = Vector2(330, 380)
	elif r == 2:
		mainTarget = Vector2(560, 230)

	targets = [
		Vector2(305, 500), # Main door
		Vector2(625, 470), # First inner door
		mainTarget, # Check-in
		Vector2(335, 210), # Before last choke
		Vector2(335, 175), # In last choke
		Vector2(800, 300)  # Final
	]

func _process(delta):
	checkIfTargetIsReached()
	if targets.size() == 0:
		host.terminate()
		return

func checkIfTargetIsReached():
	var t1 = targets[0]
	var dist = t1 - host.position
	if dist.length() < host.r:
		if t1 == mainTarget:
			host.sprite.setGreen()
		targets.erase(t1)