extends Node2D

const client_scene = preload("res://objects/client/client.tscn")
const flying_coin_scene = preload("res://objects/flying_coin/flying_coin.tscn")

@onready var entry_point := $EntryPoint
@onready var exit_point := $ExitPoint
@onready var stands := $Stands_1
@onready var client_timer := $ClientsTimer
@onready var bg_music = $BgMusic
@onready var hud = $HUD
@onready var flying_coins := $FlyingCoins
@onready var clients := $Clients

var _current_stand : Stand = null
var _money = 0
var _good_clients = 0
var _bad_clients = 0
var _unloked_stands : Array[Stand] = []

func _ready() -> void:
	_load_game_save()

	randomize()
	_init_stands()

func _load_game_save():
	var data := SaveManager.data
	_update_money(data.money)

	_good_clients = data.good_clients - 1
	_add_good_client()

	_bad_clients = data.bad_clients - 1
	_add_bad_client()

	client_timer.wait_time = SaveManager.data.client_wait_time

func _pick_random_unlocked_stand():
	return _unloked_stands.pick_random()

func _update_money(new_amount: int):
	_money += new_amount
	if _money < 0:
		_money = 0

	_actualize_stands()
	hud.update_money(_money)

	if _good_clients > 1 and _money <= 0:
		game_over()

func _add_good_client():
	_good_clients += 1
	hud.set_good_client(_good_clients)

func _add_bad_client():
	_bad_clients += 1
	hud.set_bad_client(_bad_clients)


func _init_client():
	var client := client_scene.instantiate()
	clients.add_child(client)
	client.position = Vector2(randf_range(0, 720), entry_point.position.y)
	_current_stand = _pick_random_unlocked_stand()
	client.set_target_stand(_current_stand)
	client.set_exit(exit_point)
	client.buyed.connect(_on_client_buyed)
	client.wait_ended.connect(_on_client_wait_ended)
	client.scale /= 2.8

func _show_flying_coin(client_pos: Vector2):
	var coin : FlyingCoin = flying_coin_scene.instantiate()
	flying_coins.add_child(coin)
	coin.fly(client_pos, hud.get_coin_global_position())


func _on_client_buyed(amount: int, client_pos: Vector2):
	_update_money(amount)
	_add_good_client()
	_show_flying_coin(client_pos)
	$Pickup.play()

func _on_client_wait_ended():
	_add_bad_client()
	_update_money(-1000)

func _on_clients_timer_timeout() -> void:
	for i in randi_range(1, int(_good_clients / 10.0)):
		_init_client()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is NClient:
		body.exit()

func _on_bg_music_finished() -> void:
	bg_music.play()

func _init_stands():
	for stand: Stand in stands.get_children():
		var unlocked_idx = SaveManager.data.unlocked_stands_idx.get_or_add(stands.name, [])
		if unlocked_idx and stand.name in unlocked_idx:
			stand.unlock()
			_unloked_stands.append(stand)
		else:
			stand.set_unlock_price(2500 * (1 + randi() % 10))
			stand.lock()
			stand.unlocked.connect(_on_stand_unlocked.bind(stand))

	var first_stand: Stand = stands.get_child(0)
	first_stand.unlock_price = 0
	first_stand.unlock()

func _on_stand_unlocked(stand: Stand):
	_update_money(-stand.unlock_price)
	_unloked_stands.append(stand)
	client_timer.wait_time = stands.get_child_count() - _unloked_stands.size() + 1
	SaveManager.data.client_wait_time = client_timer.wait_time
	SaveManager.data.unlocked_stands_idx.get_or_add(stands.name, []).append(stand.name)
	SaveManager.save_game()

func _actualize_stands():
	for stand: Stand in stands.get_children():
		stand.set_current_amount(_money)

func game_over():
	var __ = get_tree().change_scene_to_file("res://scenes/failed/failed_screen.tscn")
