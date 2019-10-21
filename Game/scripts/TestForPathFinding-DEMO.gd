extends Node2D

onready var nav_2d : Navigation2D = $Navigation2D
onready var line_2d : Line2D = $Line2D
onready var character : Sprite = $Character
onready var player : KinematicBody2D = $Tank

func _unhandled_input(event: InputEvent) -> void:
	
	if not event is InputEventMouseButton:
		return
	
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
	


func _on_Timer_timeout():
	
	var new_path : = nav_2d.get_simple_path(character.global_position , player.global_position)
	line_2d.points = new_path
	character.path = new_path
	print("Chamou o Timer")

func stop_timer():
	$Timer.stop()

func start_timer():
	$Timer.start()