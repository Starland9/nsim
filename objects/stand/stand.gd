extends StaticBody2D
class_name Stand

enum StandProduct {
	BEIGNETS = 2,
	PLANTAINS = 3,
	MOMO = 4,
	FISH = 5,
	DRESS = 6,
}

@onready var label = $Label
@onready var sprite = $ColorRect

@export var service_time := 5 # in second
@export var product : StandProduct = StandProduct.BEIGNETS
@export var unit_price := 50

func _ready() -> void:
	product = StandProduct.values().pick_random()
	sprite.texture = load("res://assets/images/stands/sprite_" + str(product) + ".png")


func get_product_text():
	match product:
		StandProduct.BEIGNETS: return "Beignets"
		StandProduct.PLANTAINS: return "Plantains"
		StandProduct.MOMO: return "Mobile Money"
		StandProduct.FISH: return "Poissons"
		StandProduct.DRESS: return "Vêtements"

		_: return "Produit"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is NClient:
		body.wait()
