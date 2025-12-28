extends Area2D

@export var health : int = 10
@export var max_health : int = 10
@export var damage : int = 1
@export var fire_range : int = 400
@export var fire_rate : float = 0.2 # test value
@onready var bullet_scene : PackedScene = preload("res://bullet.tscn")
var enemy_targets : Array[Node2D] = []

func _ready() -> void:
	$FireTimer.start(fire_rate)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("take damage")

func _on_fire_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("target and shoot at enemy")

func _on_fire_timer_timeout() -> void:
	var bullet : Bullet = bullet_scene.instantiate()
	
	var fake_target : Vector2 = Vector2.ZERO
	fake_target.x = randi_range(0, 1920)
	fake_target.y = randi_range(0, 1080)
	
	var angle : float = position.angle_to_point(fake_target)
	var bullet_speed : Vector2 = Vector2(800, 0)
	bullet_speed = bullet_speed.rotated(angle)
	bullet.linear_velocity = bullet_speed

	add_child(bullet)
