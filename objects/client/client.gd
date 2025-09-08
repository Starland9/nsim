extends CharacterBody2D
class_name NClient

signal wait_ended
signal buyed(amount: int)

var _walk_speed := 100
var _target_stand: Stand = null
var _exit_node: Node2D = null
var _waiting := false
@onready var dialog := $Dialog
@onready var dialog_card := $Dialog/DialogCard
@onready var dialog_wait := $Dialog/DialogWait
@onready var shape := $CollisionShape2D
@onready var sprite := $Sprite2D
@onready var pickup_sound := $Pickup


func _ready() -> void:
	_hide_dialog()

func set_target_stand(stand: Stand):
	_target_stand = stand
	sprite.modulate = Color(randf(), randf(), randf())

func set_exit(exitx: Node2D):
	_exit_node = exitx

func go_to_exit():
	wait_ended.emit()
	#shape.disabled = true
	_target_stand = null
	_waiting = false
	_hide_dialog()

func _physics_process(_delta: float) -> void:
	var _target = _target_stand if _target_stand else _exit_node if _exit_node else null
	if _target and not _waiting:
		var dist = _target.position - position
		if dist.length() < 50:
			return
		var dir = dist.normalized()
		velocity = _walk_speed * dir
		move_and_slide()

func _hide_dialog():
	dialog.hide()

func _showDialog():
	dialog.show()

func wait():
	if _target_stand:
		_waiting = true
		dialog_wait.set_max_wait_time(_target_stand.service_time)
		dialog_card.set_text(str((randi() % 10)))
		_showDialog()

func get_total_money():
	return randi() % 1000


func _on_dialog_wait_wait_time_ended() -> void:
	$"Mixkit-lost-kid-sobbing-474".play()
	go_to_exit()

func exit():
	queue_free()

func buy():
	buyed.emit(randi() % 100)
	queue_free()

func _input(event: InputEvent) -> void:
	if event is InputEventMouse and _waiting:
		if event.is_pressed():
			if event.global_position.distance_to(global_position) <= 20:
				buy()
