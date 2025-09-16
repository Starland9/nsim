extends Node

const SAVE_PATH = "user://savegame.res"

var data := SaveData.new()

func _ready() -> void:
	load_game()

func save_game() -> bool:
	return ResourceSaver.save(data, SAVE_PATH) == OK

func load_game() -> SaveData:
	if ResourceLoader.exists(SAVE_PATH):
		data = ResourceLoader.load(SAVE_PATH)
	return data

func erase_data() -> bool:
	data = SaveData.new()
	return ResourceSaver.save(data, SAVE_PATH) == OK
