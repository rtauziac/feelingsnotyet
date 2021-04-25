extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("_ready_later")


func _ready_later():
	GlobalReferences.fade_screen.fade_to_color(Color(0, 0, 0, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
