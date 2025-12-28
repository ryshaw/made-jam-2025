extends ProgressBar
class_name BaseBar

@export var label_text : String
@export var bar_color : Color = Color.WHITE

func _ready() -> void:
	$Label.text = label_text
	modulate = bar_color
