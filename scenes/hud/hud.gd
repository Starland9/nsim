extends CanvasLayer

@onready var good_clients := $Control/GoodClients
@onready var bad_clients := $Control/BadClients
@onready var money := $Control/Money

func update_money(new_amount: int):
	money.text = "X "+str(new_amount)

func set_good_client(count: int):
	good_clients.text = "Client satisfaits: " + str(count)

func set_bad_client(count: int):
	bad_clients.text = "Client insatisfaits: " + str(count)
