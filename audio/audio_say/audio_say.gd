extends AudioStreamPlayer
class_name AudioSay

var dialog_stream : AudioStream
var mouf_stream : AudioStream

func _ready() -> void:
	dialog_stream = _get_random_stream("res://assets/sfx/real_voice/")
	mouf_stream = _get_random_stream("res://assets/sfx/real_voice/moufs/")

func _get_random_stream(path: String):
	var dir := DirAccess.open(path)
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
		return load(path + choice)

func play_dialog():
	stream = dialog_stream
	play()

func play_mouf():
	stream = mouf_stream
	play()
