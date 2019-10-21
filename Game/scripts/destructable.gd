extends Area2D

export var health = 10

signal hitted(damage , health , node)
signal destroyed()


func hit (damage , node):
	health -= damage
	emit_signal("hitted", damage , health , node)
	if health <= 0:
		emit_signal("destroyed")































