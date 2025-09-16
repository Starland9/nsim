extends Control


func _ready() -> void:
	SaveManager.erase_data()
	SaveManager.load_game()

func _on_button_button_up() -> void:
	var __ = get_tree().change_scene_to_file("res://scenes/home_menu/home_menu.tscn")
