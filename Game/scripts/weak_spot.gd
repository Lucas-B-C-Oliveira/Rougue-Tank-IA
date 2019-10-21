extends Area2D

signal damage(damage , node)


func _ready():
	pass 
	
func hit(damage , node):
	emit_signal("damage" , damage , node)