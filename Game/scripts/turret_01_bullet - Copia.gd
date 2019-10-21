extends Area2D

var dir = Vector2() setget set_dir
var vel = 400
var max_dist = 300
onready var init_post = global_position

func _ready():
	pass
	
func _physics_process(delta):
	translate(dir * vel * delta)
	if global_position.distance_to(init_post) > max_dist:
		queue_free()
		
func set_dir(val):
	dir = val
	rotation = val.angle()

