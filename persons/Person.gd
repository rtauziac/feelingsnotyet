extends Sprite

class_name Person


export (Array, NodePath) var siblingpaths
export (bool) var is_open

var siblings: Array


# Called when the node enters the scene tree for the first time.
func _ready():
	for path in siblingpaths:
		var person: Person = get_node(path)
		siblings.push_front(person)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
