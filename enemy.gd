class_name Enemy extends RigidBody2D

signal give_xp_on_death(val : int)

@export var speed: float = 100.0
@export var health: int = 3
@export var damage: int = 1
@export var target: Node2D
@export var xp_on_death : int = 5
var isAlive : bool = true

func take_damage(amount : int):
	apply_central_impulse(-1 * linear_velocity)
	health -= amount
	if (health <= 0): 
		isAlive = false
		hide()
		give_xp_on_death.emit(2)

func _physics_process(_delta: float) -> void:
	var dir = Vector2(target.position.x - self.position.x,target.position.y - self.position.y).normalized()
	linear_velocity = Vector2(dir.x*speed,dir.y*speed)
