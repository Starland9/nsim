extends Node2D

const client_scene = preload("res://objects/client/client.tscn")

@onready var entry_point := $EntryPoint
@onready var exit_point := $ExitPoint
@onready var stands := $Stands
@onready var client_timer := $ClientsTimer
@onready var bg_music = $BgMusic
@onready var hud = $HUD

var _current_stand : Stand = null
var _money = 0
var _good_clients = 0
var _bad_clients = 0

func _ready() -> void:
	randomize()

func _pick_random_stand():
	var idx = randi_range(0, stands.get_child_count() - 1)
	return stands.get_child(idx)

func _update_money(new_amount: int):
	_money += new_amount
	hud.update_money(_money)

func _add_good_client():
	_good_clients += 1
	hud.set_good_client(_good_clients)

func _add_bad_client():
	_bad_clients += 1
	hud.set_bad_client(_bad_clients)
	_update_money(-500)


func _init_client():
	var client := client_scene.instantiate()
	add_child(client)
	client.position = entry_point.position
	_current_stand = _pick_random_stand()
	client.set_target_stand(_current_stand)
	client.set_exit(exit_point)
	client.buyed.connect(_on_client_buyed)
	client.wait_ended.connect(_on_client_wait_ended)
	client.scale /= 2.8

func _on_client_buyed(amount: int):
	_update_money(amount)
	_add_good_client()
	$Pickup.play()

func _on_client_wait_ended():
	_add_bad_client()


func _on_clients_timer_timeout() -> void:
	client_timer.wait_time = randf_range(0, 2)
	_init_client()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is NClient:
		body.exit()


func _on_bg_music_finished() -> void:
	bg_music.play()
