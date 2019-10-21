extends Area2D

var target
var rot_vel = PI
var vel = 100
var homming = false

func _ready():
	yield(get_tree().create_timer(.3) , "timeout")
	homming = true

func _process(delta):
	if target:
		if homming:
			var angle = get_angle_to(target.global_position)
			if abs(angle) > .01:
				rotation += rot_vel * delta * sign(angle)
	translate(Vector2(cos(rotation) , sin(rotation)).normalized() * vel * delta)


func _on_home_missel_body_entered(body):
	destroy()



func destroy():
	$area_damage.queue_free()
	$sprite.hide()
	$shape.queue_free()
	set_process(false)
	$smoke.emitting = false
	$fire.emitting = false
	$explosion.play("boom")
	yield(get_tree().create_timer(2) , "timeout")
	queue_free()

func _on_area_damage_destroyed():
	destroy()


func _on_area_damage_area_entered(area):
	if area.has_method("hit"):
		area.hit(60 , self)
	destroy()
