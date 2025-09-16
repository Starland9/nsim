extends Resource
class_name SaveData

@export var money: int = 500
@export var good_clients: int = 0
@export var bad_clients: int = 0
@export var client_wait_time: int = 3

@export var unlocked_stands_idx: Dictionary[String, Array] = {}
