# STEERING BEHAVIOR MANAGER

# This is accumulating a force resulting from applied steering behaviors
# The final force is accumulated in 'steer' and multiplied by MAX_FORCE
# This force is then applied to the the hosts velocity to change it's movement

extends Node2D

onready var host = get_parent()

# Global steering force
var steer = Vector2()
var brake = Vector2()

# Global Config
export var MAX_FORCE = 0.5   # Multiplier for accumulated steering force
export var MAX_BRAKING_FORCE = 0.01 # Multiplier for negative Velocity
 # Config for single behaviors
export var SLOWING_RADIUS = 100   # Seek // Radius when starting to slow down
export var CIRCLE_DISTANCE = 2   # Wander // Mutiplied with maxSpeed

#####################################################
# MOVE BASED ON STEER AND BRAKE

func update():
	# Apply steer to Velocity
	steer = steer.clamped(MAX_FORCE)
	host.data.steerForce = steer
	host.velocity += steer
	# Apply brake to Velocity
	brake = brake.clamped(MAX_BRAKING_FORCE)
	host.velocity += brake
	# Move based on velocity
	host.velocity = host.velocity.clamped(host.maxSpeed)
	host.position += host.velocity
	# Reset
	steer = Vector2()

#####################################################
# BEHAVIOR ROUTER

func seek(_target):
	if _target is Vector2:
		applySeek(_target)

func seekAndArrive(_target):
	if _target is String:
		match _target:
			"mouse": applySeekAndArrive(get_viewport().get_mouse_position())
			"center": applySeekAndArrive(Vector2(get_viewport().size.x-250, get_viewport().size.y/2))
	if _target is Vector2:
		applySeekAndArrive(_target)

func flee(_target :String):
	match _target:
		"mouse":
			var mousePos = get_viewport().get_mouse_position()
			if position.distance_to(mousePos) < 100:
				applyFlee(mousePos)

func avoid(_obstacles :Array):
	if _obstacles.size() != 0:
		applyAvoid(_obstacles)

func wander():
	applyWander()

#####################################################
# APPLY BEHAVIORS TO THE ACCUMULATED STEERING FORCE

# BRAKE
# Brake when collisions are detected
func brake():
	brake += host.velocity * -1

# SEEK
# Seek a target
func applySeek(_target :Vector2):
	var force = _target - host.position
	force = force.normalized() * host.maxSpeed
	steer += force
	
# SEEK AND ARRIVE
# Seek a target and arrive smoovely at it
func applySeekAndArrive(_target :Vector2):
	var force = _target - host.position
	var distance = force.length()
	force = force.normalized() * host.maxSpeed
	if distance < SLOWING_RADIUS:
		force = force * (distance / SLOWING_RADIUS)
		force = force - host.velocity
	steer += force

# FLEE
# Flee from a target in the opposite direction
func applyFlee(_target :Vector2):
	var force = _target - host.position
	force = force.normalized() * MAX_FORCE
	steer -= force

# AVOID
# Avoiding obstacles or other ships
func applyAvoid(_obstacles :Array): # Takes Vectors
	var force
	var mostThreatening = _obstacles[0]
	if _obstacles.size() > 1:
		for o in _obstacles:
			if host.futurePos.distance_to(o) < host.futurePos.distance_to(mostThreatening):
				mostThreatening = o
	force = host.futurePos - mostThreatening
	steer += force
	brake()

# WANDER
# Wander around with a small random displacement each frame
func applyWander():
	var circleCenter = host.velocity * CIRCLE_DISTANCE
	var r = host.maxSpeed
	var displacement = Vector2(rand_range(-r, r), rand_range(-r, r))
	var force = circleCenter + displacement
	force = force.normalized() * MAX_FORCE
	steer += force



