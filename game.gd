extends Node

enum SEASON { SPRING, SUMMER, FALL, WINTER }

var current_season : SEASON = SEASON.SPRING
var xp : int = 0
var max_xp : int = 100
var game_over : bool = false

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
	$Display/GameOver.hide()
	$Display/GameWin.hide()
	$SeasonTimer.start(5)
	while true:
		if game_over: return
		await Global.wait(1)
		var complete : float =  $SeasonTimer.wait_time - $SeasonTimer.time_left
		%SeasonBar.update_value(complete, $SeasonTimer.wait_time)
	
func _on_player_health_updated(new_val: int, max_val: int) -> void:
	if game_over: return
	%HealthBar.update_value(new_val, max_val)
	if new_val <= 0:
		$Display/GameOver.show()
		$Player.hide()
		await Global.wait(0.5)
		game_over = true
		

func _on_season_timer_timeout() -> void:
	if game_over: return
	if current_season == SEASON.WINTER:
		$Display/GameWin.show()
		$Player.hide()
		get_tree().call_group("enemy", "hide")
		await Global.wait(0.5)
		game_over = true
		return
	current_season = current_season + (1 as SEASON)
	print("next season")
	await Global.wait(1)
	$SeasonTimer.start(5)
	

func _on_enemy_timer_timeout() -> void:
	if game_over: return
	var current_enemy : Enemy = enemy_list[current_season].instantiate()
	var x : float = 0.0 if randf() < 0.5 else window_size.x
	var y : float = randf_range(0, window_size.y)
	
	current_enemy.position = Vector2(x, y)
	current_enemy.target = $Player
	current_enemy.give_xp_on_death.connect(_on_give_xp_on_death)
	add_child(current_enemy)
	
func _on_give_xp_on_death(val : int):
	if game_over: return
	xp += val
	%XPBar.update_value(xp, max_xp)

func _unhandled_input(_event: InputEvent) -> void:
	if game_over and Input.is_anything_pressed():
		get_tree().reload_current_scene()
