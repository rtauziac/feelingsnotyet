extends Sprite

class_name ParralaxElement

export (float, -1, 1) var parralax_amount = 1
var _initial_position: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	_initial_position = position


func set_parralax(_par):
	position = _initial_position + Vector2(_par * parralax_amount, 0)
