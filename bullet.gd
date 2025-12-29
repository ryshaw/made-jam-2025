extends RigidBody2D
class_name Bullet

@export var damage : int # set by player

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"): 
		body.take_damage(damage)
		queue_free()

func _process(delta: float) -> void:
	$Sprite2D.rotate(PI * 3 * delta)
