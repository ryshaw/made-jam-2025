class_name RangedEnemy extends Enemy

@export var stop_dist: float;
@export var fire_rate: float;
var can_fire: bool = false;

func _ready() -> void:
	$ShootTimer.start(fire_rate)

func _physics_process(_delta: float) -> void:
	var distance = Vector2(target.position - self.position).length();
	if(distance < stop_dist):
		linear_velocity = Vector2.ZERO;
		can_fire = true;
	else:
		var dir = Vector2(target.position.x - self.position.x,target.position.y - self.position.y).normalized()
		linear_velocity = Vector2(dir.x*speed,dir.y*speed)
	#move_and_slide()

func shoot():
	if(can_fire):
		print("FIREEEE")
	pass
