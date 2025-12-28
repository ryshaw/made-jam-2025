class_name Enemy extends RigidBody2D

@export var speed: float;
@export var health: int;
@export var damage: int; 
@export var target: Node2D;
var isAlive : bool = true

func take_damage(amount : int):
	apply_central_impulse(-1 * linear_velocity)
	health -= amount
	print("Health Left: ",health)
	if(health <= 0): 
		isAlive = false
		print("I died blehhh")

func _physics_process(_delta: float) -> void:
	var dir = Vector2(target.position.x - self.position.x,target.position.y - self.position.y).normalized()
	linear_velocity = Vector2(dir.x*speed,dir.y*speed)
