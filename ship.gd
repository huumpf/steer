extends Node2D

# GET NODES
onready var sprite = get_node("Sprite") # Plane sprite
onready var steer = get_node("Steer") # Scripts for steering behaviors
onready var sense = get_node("Sense") # Scripts for sensing own surrounding

# CONFIG
export var MAX_DEFAULT_VELOCITY = 1 # Length on each axis
export var MAX_SPEED_ADD = 1.5 # Added to initial velocity
export var BODY_RADIUS = 20 # Body radius for collision avoidance

# META
var id # Ship's id

# MOVEMENT
var velocity = Vector2() # Ship's current velocity
var steerForce = Vector2()
var maxSpeed # Maximum length of velocity vector

# SENSORS AND DETECTION
var r # Ship's radius for collisions detection
var futurePos = Vector2()
var otherShips = []
var shipCollisions = []

##################################################
# INIT

func _ready():
	# Init position
	position.x = randf() * get_viewport().size.x
	position.y = randf() * get_viewport().size.y
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
#    draw_line(Vector2(0,0), steerForce * 10, Color(0, 255, 0), 1)
	
##################################################
# PROCESS

func _process(delta):
	
	# Sense
	futurePos = sense.futurePos()
	otherShips = sense.otherShips()
	shipCollisions = sense.shipCollisions(otherShips)
	
	# Steer
#	steer.wander()
	steer.seek("mouse")
#	if position.distance_to(get_viewport().get_mouse_position()) < 100:
#		steer.flee("mouse")
	if shipCollisions.size() > 0:
		steer.avoid(shipCollisions)
	steer.update()
	
	# Other
	edge()
	sprite.rotation = velocity.angle()
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

func test():
	print("TEST ==> Ship id ", id)
