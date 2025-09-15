extends AudioStreamPlayer2D
class_name AudioSay

var dialog_stream : AudioStream
var mouf_stream : AudioStream


const base_path = "res://assets/sfx/real_voice"

func _ready() -> void:
	pitch_scale = randf_range(1.2, 1.8)
	volume_db = randf_range(-2, 10)
	mouf_stream = _get_random_stream("/moufs")

func _get_random_stream(path: String):
	var files := ResourceLoader.list_directory(base_path + "/" + path)
	if not files.is_empty():
		var choice = files[randi() % files.size()]
		var file = base_path + path + "/" + choice
		return ResourceLoader.load(file, "AudioStream", ResourceLoader.CACHE_MODE_IGNORE)



func play_dialog(stand: Stand):
	match stand.product:
		stand.StandProduct.BEIGNETS:
			dialog_stream = _get_random_stream("/beignets")
		stand.StandProduct.PLANTAINS:
			dialog_stream = _get_random_stream("/plantain")
		stand.StandProduct.MOMO:
			dialog_stream = _get_random_stream("/momo")
		stand.StandProduct.FISH:
			dialog_stream = _get_random_stream("/fish")
		stand.StandProduct.DRESS:
			dialog_stream = _get_random_stream("/dress")

	stream = dialog_stream
	play()

func play_mouf():
	stream = mouf_stream
	play()
