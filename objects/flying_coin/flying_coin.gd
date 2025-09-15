extends Sprite2D
class_name FlyingCoin

@export var duration := 0.8
@export var arc_height := 200

func fly(global_from: Vector2, global_to: Vector2) -> void:
	global_position = global_from

	var tween := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", Vector2(global_from.x, global_from.y - arc_height), duration * 0.5)
	tween.tween_property(self, "global_position", Vector2(global_to.x, global_to.y - arc_height * 0.3), duration)

#	rotation
	create_tween().set_loops().tween_property(self, "rotation", PI * 4, duration)

#	squash & stretch
	create_tween().tween_property(self, "scale", Vector2(1.3, 0.7), duration * 0.2).set_trans(Tween.TRANS_SINE)
	create_tween().tween_property(self, "scale", Vector2(0.6, 1.4), duration * 0.3).set_trans(Tween.TRANS_SINE)
	create_tween().tween_property(self, "scale", Vector2(0, 0), duration * 0.2).set_delay(duration * 0.8)

	create_tween().tween_property(self, "modulate:a", 0, duration * 0.95)

	tween.tween_callback(queue_free)
