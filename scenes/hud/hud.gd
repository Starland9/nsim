extends CanvasLayer
class_name MainHUD

@onready var good_clients := $Control/GoodClients
@onready var bad_clients := $Control/BadClients
@onready var money := $Control/CoinPanel/Money
@onready var coin := $Control/CoinPanel/Coin

var is_paused := false

func update_money(new_amount: int):
	money.text = str(new_amount)
	SaveManager.data.money = new_amount
	SaveManager.save_game()

func set_good_client(count: int):
	good_clients.text = "Client satisfaits: " + str(count)
	SaveManager.data.good_clients = count

func set_bad_client(count: int):
	bad_clients.text = "Client insatisfaits: " + str(count)
	SaveManager.data.bad_clients = count

func get_coin_global_position() -> Vector2:
	return coin.global_position + Vector2(50, 50)


func _on_pause_btn_pressed() -> void:
	is_paused = not is_paused
	get_tree().paused = is_paused
