extends Area2D

var vel = 400
var dir = Vector2()
var damage = 1
var shooter
onready var initPos = self.global_position

func _physics_process(delta):
	translate(dir * vel * delta)
	if global_position.distance_to(initPos) > 150:
		queue_free()




func _on_mg_bullet_area_entered(area):
		if area.has_method("hit"):
			area.hit(damage, self)
			queue_free()



func _on_mg_bullet_body_entered(body):
	queue_free() 
