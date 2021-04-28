extends Node2D


func move_to_position(_position):
	$Tween.interpolate_property(self, "position", position, _position, 0.7, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
