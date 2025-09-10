extends Control

@onready var clients := $Clients
@onready var stand := $Stand
@onready var play_button := $PlayBtn
@onready var bg_sound = $BgSound
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	for client : NClient in $Clients.get_children():
		client.set_target_stand(stand)
		client.scale /= 2
		client.is_menu = true

	animation_player.play("play_btn_bounce")


func _on_play_btn_button_up() -> void:
	var __ = get_tree().change_scene_to_file("res://scenes/main/main.tscn")
