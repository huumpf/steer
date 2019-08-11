extends Node2D

onready var host = get_parent()
var targets = []

func _ready():
	pass

func _process(delta):
	checkIfTargetIsReached()
	if targets.size() == 0:
		host.terminate()
		return

func checkIfTargetIsReached():
	var t1 = targets[0]
	var dist = t1 - host.position
	if dist.length() < host.r:
		targets.erase(t1)