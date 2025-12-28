extends Node

enum SEASON { SPRING, SUMMER, FALL, WINTER }

var current_season : SEASON = SEASON.SPRING

# should always be (1920, 1080)
@onready var window_size : Vector2 = get_viewport().get_visible_rect().size

@onready var enemy_list : Array[PackedScene] = [
		preload("res://enemy.tscn"),
		preload("res://rangedEnemy.tscn"),
		preload("res://enemy.tscn"),
		preload("res://enemy.tscn")
	]
	
func _ready() -> void:
	_on_enemy_timer_timeout()
	%SeasonBar.update_value(0, 1)
	%XPBar.update_value(0, 1)
	while true:
		await Global.wait(1)
		var complete : float =  $SeasonTimer.wait_time - $SeasonTimer.time_left
		%SeasonBar.update_value(complete, $SeasonTimer.wait_time)
	
func _on_player_health_updated(new_val: int, max_val: int) -> void:
	%HealthBar.update_value(new_val, max_val)
	if new_val <= 0:
		print("game over")

func _on_season_timer_timeout() -> void:
	if current_season == SEASON.WINTER:
		print("game win")
		return
	current_season = current_season + (1 as SEASON)
	print("next season")

func _on_enemy_timer_timeout() -> void:
	var current_enemy : Enemy = enemy_list[current_season].instantiate()
	var x : float = 0.0 if randf() < 0.5 else window_size.x
	var y : float = randf_range(0, window_size.y)
	
	current_enemy.position = Vector2(x, y)
	current_enemy.target = $Player
	add_child(current_enemy)
	
