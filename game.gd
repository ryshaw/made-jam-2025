extends Node

enum SEASON { SPRING, SUMMER, FALL, WINTER }
signal seasonChange(season:SEASON)
var current_season : SEASON = SEASON.SPRING
var xp : int = 0
var max_xp : int = 100
var game_over : bool = false
@export var season_length: float = 40
var default_xp_needed : int = 4
var health_xp_needed : int
var damage_xp_needed : int
var fire_rate_xp_needed : int
var range_xp_needed : int

# should always be (1920, 1080)
@onready var window_size : Vector2 = get_viewport().get_visible_rect().size

@onready var enemy_list : Array[PackedScene] = [
		preload("res://enemy.tscn"),
		preload("res://fast_enemy.tscn"),
		preload("res://rangedEnemy.tscn"),
		preload("res://big_enemy.tscn")
	]
	
func _ready() -> void:
	_on_enemy_timer_timeout()
	%SeasonBar.update_value(0, 1)
	%XPBar.update_value(0, 1)
	$Display/GameOver.hide()
	$Display/GameWin.hide()
	$SeasonTimer.start(season_length)
	seasonChange.emit(current_season)
	reset_upgrade_buttons()
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
	emit_signal("seasonChange",current_season)
	reset_upgrade_buttons()
	await Global.wait(1)
	$SeasonTimer.start(season_length)
	

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
		return
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
		var any_focused = false
		if %HealthButton.has_focus(): any_focused = true
		elif %DamageButton.has_focus(): any_focused = true
		elif %FireRateButton.has_focus(): any_focused = true
		elif %RangeButton.has_focus(): any_focused = true
		if not any_focused: %HealthButton.call_deferred("grab_focus")
	
func reset_upgrade_buttons():
	health_xp_needed = default_xp_needed
	damage_xp_needed = default_xp_needed
	fire_rate_xp_needed = default_xp_needed
	range_xp_needed = default_xp_needed
	%HealthCost.text = "XP Cost: " + str(health_xp_needed) + "%"
	%DamageCost.text = "XP Cost: " + str(damage_xp_needed) + "%"
	%FireRateCost.text = "XP Cost: " + str(fire_rate_xp_needed) + "%"
	%RangeCost.text = "XP Cost: " + str(range_xp_needed) + "%"

func _on_health_button_pressed() -> void:
	if xp >= health_xp_needed:
		xp -= health_xp_needed
		%XPBar.update_value(xp, max_xp)
		update_upgrade_costs("health")
		$Player.max_health += 5
		$Player.health += 8
		$Player.health = clampi($Player.health, 0, $Player.max_health)
		%HealthBar.update_value($Player.health, $Player.max_health)
		
func _on_damage_button_pressed() -> void:
	if xp >= damage_xp_needed:
		xp -= damage_xp_needed
		%XPBar.update_value(xp, max_xp)
		update_upgrade_costs("damage")
		$Player.damage += 1
		
func _on_fire_rate_button_pressed() -> void:
	if xp >= fire_rate_xp_needed:
		xp -= fire_rate_xp_needed
		%XPBar.update_value(xp, max_xp)
		update_upgrade_costs("fire_rate")
		$Player.fire_rate *= 0.7
		
func _on_range_button_pressed() -> void:
	if xp >= range_xp_needed:
		xp -= range_xp_needed
		%XPBar.update_value(xp, max_xp)
		update_upgrade_costs("range")
		$Player.fire_range *= 1.2
		print($Player.fire_range)
		$Player.queue_redraw()

func update_upgrade_costs(except_for : String):
	health_xp_needed += 4
	damage_xp_needed += 4
	fire_rate_xp_needed += 4
	range_xp_needed += 4
	
	match except_for:
		"health": health_xp_needed -= 2
		"damage": damage_xp_needed -= 2
		"fire_rate": fire_rate_xp_needed -= 2
		"range": range_xp_needed -= 2
		
	%HealthCost.text = "XP Cost: " + str(health_xp_needed) + "%"
	%DamageCost.text = "XP Cost: " + str(damage_xp_needed) + "%"
	%FireRateCost.text = "XP Cost: " + str(fire_rate_xp_needed) + "%"
	%RangeCost.text = "XP Cost: " + str(range_xp_needed) + "%"
