extends Enemy
@export var stop_dist: float;
@export var fire_rate: float;


func _physics_process(delta: float) -> void:
	
	var distance = Vector2(target.position - self.position).length();
	print(distance)
	if(distance < stop_dist):
		velocity = Vector2.ZERO;
		shoot()
	else:
		var dir = Vector2(target.position.x - self.position.x,target.position.y - self.position.y).normalized()
		velocity = Vector2(dir.x*speed,dir.y*speed)
	move_and_slide()

func shoot():
	pass
