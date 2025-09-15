extends Node2D
class_name DialogWait

signal wait_time_ended

@onready var timer := $Timer
@onready var progress_bar := $ProgressBar

var _max_wait_time := 10

func set_max_wait_time(_time: int):
	_max_wait_time = 5 + randi() % 5
	progress_bar.max_value = _max_wait_time
	progress_bar.value = _max_wait_time
	timer.start()

func _process(_delta: float) -> void:
	pass

func _set_progress_bar_color():
	var ratio = progress_bar.value / progress_bar.max_value
	if ratio > 0.5:
		progress_bar.modulate = Color.BLUE
	if ratio < 0.5:
		progress_bar.modulate = Color.RED
	else:
		progress_bar.modulate = Color.GREEN

func _on_timer_timeout() -> void:
	progress_bar.value -= 0.1

func _on_progress_bar_value_changed(value: float) -> void:
	_set_progress_bar_color()
	if value <= 0:
		wait_time_ended.emit()
