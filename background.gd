extends AnimatedSprite2D


func _on_game_season_change(season: int) -> void:
	self.frame = season 
