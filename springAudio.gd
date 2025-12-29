extends AudioStreamPlayer2D

@onready var st = stream as AudioStreamSynchronized
var currentStem = 1


# Called when the node enters the scene tree for the first time.
func add_next_stem():
	print("asdsada")
	st.set_sync_stream_volume(currentStem,0)
	currentStem += 1



func _on_timer_2_timeout() -> void:
	print("ASDSAD")
	self.queue_free()
