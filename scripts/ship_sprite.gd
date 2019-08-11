extends Sprite

onready var host = get_parent()

func _ready():
	pass

func _process(delta):
#	rotation = host.data.medianVelocity.angle()
	var desiredVel = host.plan.targets[0] - host.position
	rotation = desiredVel.angle()