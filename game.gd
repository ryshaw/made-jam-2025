extends Node
	
func _on_player_health_updated(new_val: int, max_val: int) -> void:
	%HealthBar.update_value(new_val, max_val)
	if new_val <= 0:
		print("game over")
