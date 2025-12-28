extends ProgressBar
class_name BaseBar

@export var label_text : String = "BaseBar"
@export var bar_color : Color = Color.WHITE
var update_tween : Tween

func _ready() -> void:
	$Label.text = label_text
	modulate = bar_color

func update_value(current_val : int, max_val : int):
	var progress = (current_val * 100.0) / max_val
	if update_tween: update_tween.kill(); update_tween = null
	
	update_tween = create_tween()
	update_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	update_tween.tween_property(self, "value", progress, 0.6)
	
	
