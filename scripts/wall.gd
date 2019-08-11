extends Node2D

var a = Vector2()
var b = Vector2()
var v = Vector2()

func init(_a :Vector2, _b :Vector2):
	a = _a
	b = _b
	v = b - a

func _ready():
	pass

func _draw():
    draw_line(a, b, Color(255, 255, 255), 1)