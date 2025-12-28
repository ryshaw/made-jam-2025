extends Node

signal example_global_signal()
signal tick() # for keeping movements in sync
signal game_restarted()

const t : float = 0.6 # tick speed

func signal_blast():
	example_global_signal.emit()

func wait(seconds : float) -> Signal: 
	return get_tree().create_timer(seconds).timeout

const QUIT_ENABLED = true

func _unhandled_input(event: InputEvent) -> void:
	if not QUIT_ENABLED: return
	if event.is_action_pressed("ui_cancel"): quit()
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Q: quit()
		if event.keycode == KEY_R: 
			get_tree().reload_current_scene()
			game_restarted.emit()
			
func quit():
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()

func _enter_tree() -> void: while true: await wait(t); tick.emit()

func wait_ticks(num_ticks : int): # wait for a number of ticks
	await wait(t * num_ticks)
	return
