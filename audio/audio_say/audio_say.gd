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
	var full_path = base_path + path
	var dir := DirAccess.open(full_path)
	var files : Array[String] = []
	if dir:
		dir.list_dir_begin()
		var file := dir.get_next()
		while not file.is_empty():
			if not dir.current_is_dir() and file.ends_with(".wav"):
				files.append(file)
			file = dir.get_next()
		dir.list_dir_end()

	if not files.is_empty():
		var choice = files.pick_random()
		var file = full_path + "/" + choice
		var sound := AudioStreamWAV.load_from_file(file)
		return sound

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
