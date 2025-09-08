extends StaticBody2D
class_name Stand

@onready var label = $Label

@export var service_time := 5 # in second
@export var product_name := "Bananes"
@export var unit_price := 50

func _ready() -> void:
	label.text = product_name


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is NClient:
		body.wait()
