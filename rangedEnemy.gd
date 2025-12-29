class_name RangedEnemy extends Enemy

@export var stop_dist: float;
@export var fire_rate: float;
var can_fire: bool = false;
var bullet_scene : PackedScene = preload("res://enemy_bullet.tscn")
var bullet_velocity : Vector2 = Vector2.ZERO # velocity for bullets

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
		bullet_velocity = linear_velocity

func shoot():
	if (can_fire):
		var bullet : EnemyBullet = bullet_scene.instantiate()
		bullet.linear_velocity = bullet_velocity * speed * 0.5
		bullet.damage = damage
		add_child(bullet)
