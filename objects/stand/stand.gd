extends StaticBody2D
class_name Stand

signal unlocked(amount: int)

enum StandProduct {
	BEIGNETS = 2,
	PLANTAINS = 3,
	MOMO = 4,
	FISH = 5,
	DRESS = 6,
}

@onready var sprite := $ColorRect
@onready var lock_node := $Lock
@onready var lock_label := $Lock/Label
@onready var lock_key = $LockKey
@onready var powerup_sound := $Powerup

@export var product : StandProduct = StandProduct.BEIGNETS
@export var unlock_price := 10000
@export var is_active := false
@export var can_unlock := false
var _current_amount := 0
@export var service_time := 10

func _ready() -> void:
	product = StandProduct.values().pick_random()
	sprite.texture = load("res://assets/images/stands/sprite_" + str(product) + ".png")
	lock()

func set_unlock_price(price: int):
	unlock_price = price
	lock_label.text = str(price)

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

func lock():
	is_active = false
	sprite.modulate.a = 0.5
	lock_node.show()
	lock_key.hide()


func unlock():
	if is_active: return

	is_active = true
	sprite.modulate.a = 1
	lock_node.hide()
	lock_key.hide()
	unlocked.emit(unlock_price)


func set_current_amount(amount):
	if is_active: return
	_current_amount = amount
	can_unlock = _current_amount >= unlock_price

	if can_unlock:
		lock_key.show()
		lock_node.hide()
	else: lock()


func _on_lock_key_button_up() -> void:
	powerup_sound.play()
	unlock()
