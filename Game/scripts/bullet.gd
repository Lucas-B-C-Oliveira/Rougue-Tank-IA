extends Area2D

var max_dist = 250

var vel = 750
var dir = Vector2(0 , -1) setget set_dir
var damage = 10
var shooter
onready var init_pos = global_position

var live = true

func _ready():
	pass 

func _process(delta):
	
	if live:
		if global_position.distance_to(init_pos) >= max_dist:
			autoDestroy()
		
		translate(dir * vel * delta)



func _on_notifier_screen_exited():
	queue_free()

func set_dir(val):
	dir = val
	rotation = dir.angle()

func _on_bullet_body_entered(body):
	if body.collision_layer == 4:
		autoDestroy()

func autoDestroy():
	$smoke.emitting = false
	live = false
	$sprite.visible = false
	$anim_self_destruction.play("explode")
	call_deferred("set_monitoring" , false)
	call_deferred("set_monitorable" , false)
	yield($anim_self_destruction , "animation_finished")
	queue_free()
















func _on_bullet_area_entered(area):
	if area.has_method("hit"):
		area.hit(damage, self)
		autoDestroy()