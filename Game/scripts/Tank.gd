tool
extends KinematicBody2D

onready var BULLET_TANK_GROUP = "bullet-" + str(self)

const ROT_VEL = PI 
const MAX_SPEED = 200
const DEAD_ZONE = 0.02

var pre_bullet = preload("res://Scenes/bullet.tscn")
var pre_track = preload("res://Scenes/track.tscn")
var pre_mg_bullet = preload("res://Scenes/mg_bullet.tscn")
var acell = 0
var travel = 0
var can_mouse_look = false
var loaded = true

signal cannon_shooted
signal hmg_shooted



export(int, "bigRed", "blue", "dark", "green", "red", "sand", "huge") var bodie = 0 setget set_bodie
export(int, "tankDark", "tankGreen", "tankRed", "tankSand", "tankBlue", "specialBarrel") var barrel = 4 setget set_barrel

var bodies = [
	"res://sprites/tankBody_bigRed.png",
	"res://sprites/tankBody_blue.png",
	"res://sprites/tankBody_dark.png",
	"res://sprites/tankBody_green.png",
	"res://sprites/tankBody_red.png",
	"res://sprites/tankBody_sand.png",
	"res://sprites/tankBody_huge.png"
]

var barrels = [
	"res://sprites/tankDark_barrel1_outline.png",
	"res://sprites/tankGreen_barrel1_outline.png",
	"res://sprites/tankRed_barrel1_outline.png",
	"res://sprites/tankSand_barrel1_outline.png",
	"res://sprites/tankBlue_barrel1_outline.png",
	"res://sprites/specialBarrel5_outline.png"
]

func _draw():
	$sprite.texture = load(bodies[bodie])
	$barrel/sprite.texture = load(barrels[barrel])
	pass

func _ready():
	pass 

func _input(event):
	if event is InputEventMouseMotion:
		can_mouse_look = true

func _physics_process(delta):
	
	if Engine.editor_hint:
		return
		
	var vel_mode = 1
	
	if get_tree().get_nodes_in_group(str(self) + "-oil").size() > 0:
		vel_mode = .3
	
#	var dir_x = 0
#	var dir_y = 0
#
#	if Input.is_action_pressed("ui_right"):
#		dir_x += 1
#
#	if Input.is_action_pressed("ui_left"):
#		dir_x -= 1
#
#	if Input.is_action_pressed("ui_down"): 
#		dir_y += 1
#
#	if Input.is_action_pressed("ui_up"):
#		dir_y -= 1
#
	if Input.is_action_just_pressed("ui_shoot") and loaded:
#		if get_tree().get_nodes_in_group(BULLET_TANK_GROUP).size() < 3:
		var bullet = pre_bullet.instance()
		bullet.global_position = $barrel/muzzle.global_position
		bullet.dir = Vector2( cos($barrel.global_rotation) , sin($barrel.global_rotation)).normalized()
		bullet.add_to_group(BULLET_TANK_GROUP)
		bullet.max_dist = $barrel/sight.position.x - ($barrel/muzzle.position.x * 1.499)
		bullet.shooter = self
		$"../".add_child(bullet)
		$barrel/anim.play("fire")
		loaded = false
		$barrel/sight.update()
		$timer_reload.start()
		$barrel/barrel_anim.play("shoot")
		#get_parent() = $"../"
#		$smp_cannon.play()
		emit_signal("cannon_shooted")
		
	if Input.is_action_just_pressed("machineGun"):
		shoot_mg()
		$timer_mg.start()
		
	if Input.is_action_just_released("machineGun"):
		$timer_mg.stop()
#
#	look_at(get_global_mouse_position())
#
#	move_and_slide(Vector2(dir_x , dir_y) * speed)
	
	var rot = 0
	var dir = 0
	
	


	if Input.is_action_pressed("ui_right"):
		rot += 1

	if Input.is_action_pressed("ui_left"):
		rot -= 1

	if rot == 0:
		rot = Input.get_joy_axis(0 , JOY_AXIS_0)

	if Input.is_action_pressed("ui_up"):
		dir += 1

	if Input.is_action_pressed("ui_down"): 
		dir -= 1

	if dir == 0:
		dir = -Input.get_joy_axis(0 , JOY_AXIS_1)

	rotate(ROT_VEL * rot * delta)
	
#	if dir != 0:
	acell = lerp(acell, MAX_SPEED * dir, .01)
#	else:
#		acell = lerp(acell, 0, .05)
	
	var move = move_and_slide(Vector2(cos(rotation), sin(rotation)) * acell * vel_mode)
	
	travel += move.length() * delta
	
	if travel > $sprite.texture.get_size().y:
		travel = 0
		var track = pre_track.instance()
		track.global_position = global_position - Vector2(cos(rotation), sin(rotation)).normalized() * 5
		track.rotation = rotation
		track.z_index = z_index - 1
		$"../".add_child(track)

	var r_hor_axis = Input.get_joy_axis(0 , JOY_AXIS_2)

	if abs(r_hor_axis) < DEAD_ZONE:
		r_hor_axis = 0

	var r_ver_axis = Input.get_joy_axis(0 , JOY_AXIS_3)

	if abs(r_ver_axis) < DEAD_ZONE:
		r_ver_axis = 0

	if r_hor_axis != 0 or r_ver_axis != 0:
		
		var vector = Vector2(r_hor_axis , r_ver_axis)
		if vector.length() > .8:
			$barrel.global_rotation = vector.normalized().angle()
			can_mouse_look = false


	if can_mouse_look:
		$barrel.look_at(get_global_mouse_position())
	
func set_bodie(val):
	bodie = val
	if Engine.editor_hint:
		update()
		
func set_barrel(val):
	barrel = val
	if Engine.editor_hint:
		update()


func _on_timer_reload_timeout():
	loaded = true
	$barrel/sight.update()

func shoot_mg():
	var mg = pre_mg_bullet.instance()
	mg.global_position = $mg_muzzle.global_position
	mg.global_rotation = global_rotation
	mg.dir = Vector2(cos(global_rotation) , sin(global_rotation)).normalized()
	mg.shooter = self
	get_parent().add_child(mg)
#	$smp_mg.play()
	emit_signal("hmg_shooted")


func _on_timer_mg_timeout():
	shoot_mg()


func _on_damage_area_destroyed():
	queue_free()
