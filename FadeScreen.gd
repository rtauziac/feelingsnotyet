extends ColorRect

class_name FadeScreen

signal fade_did_finish


export (float) var fade_duration = 1.3


func _ready():
	GlobalReferences.fade_screen = self
	color = Color.black


func fade_to_color(dest_color: Color):
	$Tween.stop_all()
	$Tween.interpolate_property(self, "color", color, dest_color, fade_duration,Tween.TRANS_LINEAR)
	$Tween.start()
	$Timer.wait_time = fade_duration
	$Timer.connect("timeout", self, "_end_fade_signal", [], CONNECT_ONESHOT)
	$Timer.start()


func _end_fade_signal():
	emit_signal("fade_did_finish")
