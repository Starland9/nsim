extends CanvasLayer
class_name MainHUD

@onready var good_clients := $Control/GoodClients
@onready var bad_clients := $Control/BadClients
@onready var money := $Control/CoinPanel/Money
@onready var coin := $Control/CoinPanel/Coin

@onready var coin_image = preload("res://assets/images/gui/Icon_Small_Coin.svg")

func update_money(new_amount: int):
	money.text = str(new_amount)

func set_good_client(count: int):
	good_clients.text = "Client satisfaits: " + str(count)

func set_bad_client(count: int):
	bad_clients.text = "Client insatisfaits: " + str(count)

func get_coin_global_position() -> Vector2:
	return coin.global_position + Vector2(50, 50)
