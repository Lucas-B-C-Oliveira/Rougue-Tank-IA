extends StaticBody2D

const PRE_FRAGMENTS = preload("res://Scenes/fragments/create_box_fragments.tscn")

var last_hit_node 

func _ready():
	$area_obstacle.connect("hitted" , self , "on_area_hitted")
	$area_obstacle.connect("destroyed" , self , "on_area_destroyed")
	
	
func on_area_hitted(damage, health, node):
	last_hit_node = node
	if damage > 5:
		$anim.play("big_hit")
	else:
		$anim.play("small_hit")
	
func on_area_destroyed():
	$CollisionShape2D.queue_free()
	$area_obstacle.queue_free()
	$sprite.visible = false	
	var fragments = PRE_FRAGMENTS.instance()
	fragments.global_position = global_position
	fragments.scale = scale
	get_parent().add_child(fragments)
	$breaking.play()
	if last_hit_node and "shooter" in last_hit_node:
		if last_hit_node.shooter.get_filename() == "res://Scenes/Tank.tscn":
			GAME_MANAGER.add_score(50)
	yield($breaking , "finished")	
	queue_free()
