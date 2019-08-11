extends Node

#onready var host = get_parent()

#var MED_VELOCITY_FRAMES = 10 # No of Frames calculated into median velocity

#var medianVelocity = Vector2()
#var velocities = []
var steerForce = Vector2()

func _ready():
	pass

#func _process(delta):
#	calcMedianVelocity()
#
#func calcMedianVelocity():
#	velocities.insert(0, host.velocity)
#	if velocities.size() > MED_VELOCITY_FRAMES:
#		velocities.remove(MED_VELOCITY_FRAMES)
#	medianVelocity = Vector2()
#	for v in velocities:
#		medianVelocity += v