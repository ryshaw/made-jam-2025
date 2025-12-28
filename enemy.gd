class_name Enemy extends CharacterBody2D

@export var speed: float;
@export var health: int;
@export var damage: int; 
@export var target: Node2D;
var isAlive: bool;

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	var dir = Vector2(target.position.x - self.position.x,target.position.y - self.position.y).normalized()
	velocity = Vector2(dir.x*speed,dir.y*speed)
	move_and_slide()
