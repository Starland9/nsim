extends Node2D

const client_scene = preload("res://objects/client/client.tscn")
const flying_coin_scene = preload("res://objects/flying_coin/flying_coin.tscn")

@onready var entry_point := $EntryPoint
@onready var exit_point := $ExitPoint
@onready var stands := $Stands
@onready var client_timer := $ClientsTimer
@onready var bg_music = $BgMusic
@onready var hud = $HUD
@onready var flying_coins := $FlyingCoins

var _current_stand : Stand = null
var _money = 500
var _good_clients = 0
var _bad_clients = 0

func _ready() -> void:
	randomize()
	_init_stands()

func _pick_random_stand():
	var idx = randi_range(0, stands.get_child_count() - 1)
	var picked: Stand = stands.get_child(idx)
	if not picked.is_active:
		return stands.get_child(0)
	return stands.get_child(idx)

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
	add_child(client)
	client.position = Vector2(randf_range(0, 400), entry_point.position.y)
	_current_stand = _pick_random_stand()
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
	if _good_clients != 0 and _good_clients % 5 == 0 and client_timer.wait_time >= 0.2:
		client_timer.wait_time -= .1
	_init_client()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is NClient:
		body.exit()

func _on_bg_music_finished() -> void:
	bg_music.play()

func _init_stands():
	for stand: Stand in stands.get_children():
		stand.set_unlock_price(2500 * (1 + randi() % 10))
		stand.unlocked.connect(_on_stand_unlocked)

	var first_stand: Stand = stands.get_child(0)
	first_stand.unlock()

func _actualize_stands():
	for stand: Stand in stands.get_children():
		stand.set_current_amount(_money)

func _on_stand_unlocked(amount: int):
	_update_money(-amount)

func game_over():
	var __ = get_tree().change_scene_to_file("res://scenes/failed/failed_screen.tscn")
