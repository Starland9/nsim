extends Node2D
class_name DialogCard

@onready var label = $Label
var _text := ""

func set_text(text):
	_text = text
	label.text = text
