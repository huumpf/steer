# STEERING BEHAVIOR MANAGER

# This is accumulating a force resulting from applied steering behaviors
# The final force is accumulated in 'steer' and multiplied by MAX_FORCE
# This force is then applied to the the hosts velocity to change it's movement

extends Node2D

onready var host = get_parent()

# Global steering force
var steer = Vector2()

# Global Config
export var MAX_FORCE = 0.5   # Multiplier for accumulated steering force
 # Config for single behaviors
export var SLOWING_RADIUS = 100   # Seek // Radius when starting to slow down
export var CIRCLE_DISTANCE = 2   # Wander // Mutiplied with maxSpeed
export var BRAKE_MULT = 0.8   # Brake // Multiplier for braking force

#####################################################
# MOVE BASED ON STEER AND BRAKE

func update():
	host.steerForce = Vector2(steer.x, steer.y)
	# Apply steer to Velocity
	steer = steer.clamped(MAX_FORCE)
	host.velocity += steer
	# Move based on velocity
	host.velocity = host.velocity.clamped(host.maxSpeed)
	host.position += host.velocity
	# Reset
	steer = Vector2()

#####################################################
# BEHAVIOR ROUTER

func seek(_target :String):
	match _target:
		"mouse": applySeek(get_viewport().get_mouse_position())

func flee(_target :String):
	match _target:
		"mouse": applyFlee(get_viewport().get_mouse_position())

func avoid(_obstacles :Array):
	if _obstacles.size() != 0:
		applyAvoid(_obstacles)

func wander():
	applyWander()

#####################################################
# APPLY BEHAVIORS TO THE ACCUMULATED STEERING FORCE

# SEEK
# Seek a target and arrive smoovely at it
func applySeek(_target :Vector2):
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
func applyAvoid(_obstacles :Array):
	var force
	var mostThreatening = _obstacles[0]
	if _obstacles.size() > 1:
		for o in _obstacles:
			if host.futurePos.distance_to(o.futurePos) < host.futurePos.distance_to(mostThreatening.futurePos):
				mostThreatening = o
	force = host.futurePos - mostThreatening.futurePos
	steer += force

# WANDER
# Wander around with a small random displacement each frame
func applyWander():
	var circleCenter = host.velocity * CIRCLE_DISTANCE
	var r = host.maxSpeed
	var displacement = Vector2(rand_range(-r, r), rand_range(-r, r))
	var force = circleCenter + displacement
	force = force.normalized() * MAX_FORCE
	steer += force



