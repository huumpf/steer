extends Node2D

# GET NODES
onready var steer = get_node("Steer") # Scripts for steering behaviors
onready var sense = get_node("Sense") # Scripts for sensing own surrounding
onready var plan = get_node("Plan") # Scripts for making plans on what to do
onready var sprite = get_node("Sprite") # Scripts for making plans on what to do
onready var data = get_node("Data") # Data storage

# CONFIG
export var MAX_DEFAULT_VELOCITY = 0.2 # Length on each axis
export var MAX_SPEED_ADD = 1.5 # Added to initial velocity
export var BODY_RADIUS = 18 # Body radius for collision avoidance

# META
var id # Ship's id

# MOVEMENT
var velocity = Vector2() # Ship's current velocity
var maxSpeed # Maximum length of velocity vector

# SENSORS AND DETECTION
var r # Ship's radius for collision-detection
var futurePos = Vector2() # Ships future position
var shipCollisions = [] # Ship-collisions, given futurePos
var wallCollisions = [] # Wall-collisions, given futurePos

##################################################
# INIT

func _ready():
	# Init velocity
	velocity.x = (randf() * (MAX_DEFAULT_VELOCITY * 2)) - MAX_DEFAULT_VELOCITY
	velocity.y = (randf() * (MAX_DEFAULT_VELOCITY * 2)) - MAX_DEFAULT_VELOCITY
	# Init maxSpeed
	maxSpeed = velocity.length() + MAX_SPEED_ADD
	# Init radius
	r = BODY_RADIUS

func _draw():
	pass
#    draw_line(Vector2(0,0), velocity * 10, Color(255, 0, 0), 1)
#    draw_line(Vector2(0,0), data.steerForce * 30, Color(0, 255, 0), 1)
	
##################################################
# PROCESS

func _process(delta):
	
	# Sense
	futurePos = sense.futurePos()
	shipCollisions = sense.shipCollisions()
	wallCollisions = sense.wallCollisions()
	
	# Steer
#	steer.wander()
#	steer.seek("mouse")
	steer.seek(plan.targets[0])
#	steer.flee("mouse")
	if shipCollisions.size() > 0:
		steer.avoid(shipCollisions)
	if wallCollisions.size() > 0:
		steer.avoid(wallCollisions)
	steer.update()
	
	# Other
#	edge()
	# Reset
	shipCollisions = []
	update()
	
##################################################
# RESET ON VIEWPORT EDGES

func edge():
	if position.x > get_viewport().size.x:
		position.x = 0
	if position.y > get_viewport().size.y:
		position.y = 0
	if position.x < 0:
		position.x = get_viewport().size.x
	if position.y < 0:
		position.y = get_viewport().size.y

func terminate():
	sense.world.ships.erase(self)
	self.queue_free()
