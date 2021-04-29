extends Node2D


func move_to_position(_position):
#	$Tween.interpolate_property(self, "position", position, _position, 0.4, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.interpolate_method(self, "_interp_pos", position, _position, 0.7, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()

func _interp_pos(_pos):
	position = Vector2(round(_pos.x), round(_pos.y))
