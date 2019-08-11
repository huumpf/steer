extends Sprite

onready var host = get_parent()
var green = preload("res://img/circle_green.png")

func _ready():
	pass

func _process(delta):
	pass
#	rotation = host.data.medianVelocity.angle()
#	var desiredVel = host.plan.targets[0] - host.position
#	rotation = desiredVel.angle()

func setGreen():
	self.set_texture(green)