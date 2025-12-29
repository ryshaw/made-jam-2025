class_name Player extends Area2D

signal health_updated(new_val : int, max_val : int)

var default_health : int = 10
var default_damage : int = 1
var default_fire_rate : float = 0.6
var default_range : int = 350

@export var health : int = 10
@export var max_health : int = 10
@export var damage : int = 1
@export var fire_range : int = 150
@export var fire_rate : float = 0.6
@onready var bullet_scene : PackedScene = preload("res://bullet.tscn")
var enemy_targets : Array[Enemy] = []
@onready var sprite = $Sprite2D
var current_target : Enemy

func _ready() -> void:
	$FireTimer.start(fire_rate)
	health_updated.emit(health, max_health)
	var shape : CircleShape2D = $FireRange/CollisionShape2D.shape
	shape.radius = fire_range

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		var enemy : Enemy = body as Enemy
		if enemy: 
			health -= enemy.damage
			health_updated.emit(health, max_health)
			enemy_targets.erase(enemy)
			current_target = null
			enemy.isAlive = false
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
	if health <= 0: return
	if current_target and not current_target.isAlive:
		enemy_targets.erase(current_target)
		current_target.queue_free()
		current_target = null
		
	if not current_target:
		if enemy_targets.is_empty(): return
		else:
			if is_instance_valid(enemy_targets.get(0)):
				current_target = enemy_targets.get(0)
			else: 
				enemy_targets.remove_at(0)
				return
	
	var bullet : Bullet = bullet_scene.instantiate()
	
	var angle : float = position.angle_to_point(current_target.position)
	var bullet_speed : Vector2 = Vector2(500, 0)
	bullet_speed = bullet_speed.rotated(angle)
	bullet.linear_velocity = bullet_speed
	bullet.damage = damage
	bullet.show_behind_parent = true
	add_child(bullet)
	$FireTimer.start(fire_rate)

func _on_game_season_change(season: int) -> void:
	sprite.frame = season
	max_health = default_health
	health = max_health
	damage = default_damage
	fire_rate = default_fire_rate
	fire_range = default_range
	queue_redraw()
	var shape : CircleShape2D = $FireRange/CollisionShape2D.shape
	shape.radius = fire_range

func _draw():
	var c : Color = Color.ROSY_BROWN
	c.a = 0.4
	draw_circle(Vector2.ZERO, fire_range, c)
	var shape : CircleShape2D = $FireRange/CollisionShape2D.shape
	shape.radius = fire_range
