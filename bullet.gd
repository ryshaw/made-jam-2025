extends RigidBody2D
class_name Bullet

@export var damage : int # set by player

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"): 
		print("enemy take damage")
		queue_free()
