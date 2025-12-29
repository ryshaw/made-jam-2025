extends Area2D

signal health_updated(new_val : int, max_val : int)

@export var health : int = 10
@export var max_health : int = 10
@export var damage : int = 1
@export var fire_range : int = 300
@export var fire_rate : float = 0.5
@onready var bullet_scene : PackedScene = preload("res://bullet.tscn")
var enemy_targets : Array[Enemy] = []
var current_target : Enemy

func _ready() -> void:
	$FireTimer.start(fire_rate)
	health_updated.emit(health, max_health)
	var r : CircleShape2D = CircleShape2D.new()
	r.radius = fire_range
	$FireRange/CollisionShape2D.shape = r

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		var enemy : Enemy = body as Enemy
		if enemy: 
			health -= enemy.damage
			health_updated.emit(health, max_health)
			enemy_targets.erase(enemy)
			current_target = null
			enemy.queue_free()
		else:
			var enemy_bullet : EnemyBullet = body as EnemyBullet
			if enemy_bullet: 
				health -= enemy_bullet.damage
				health_updated.emit(health, max_health)
				enemy_bullet.queue_free()

func _on_fire_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		var enemy : Enemy = body as Enemy
		if not enemy: return
		enemy_targets.append(enemy)

func _on_fire_timer_timeout() -> void:
	if current_target and not current_target.isAlive:
		enemy_targets.erase(current_target)
		current_target.queue_free()
		current_target = null
		
	if not current_target:
		if enemy_targets.is_empty(): return
		else: current_target = enemy_targets.get(0)
	
	var bullet : Bullet = bullet_scene.instantiate()
	
	var angle : float = position.angle_to_point(current_target.position)
	var bullet_speed : Vector2 = Vector2(1000, 0)
	bullet_speed = bullet_speed.rotated(angle)
	bullet.linear_velocity = bullet_speed
	bullet.damage = damage

	add_child(bullet)
