extends Node2D

class_name Person, "res://editor/icons/dog.png"


export (String, MULTILINE) var siblingpaths
export (bool) var is_open

var siblings: Array

var fog: bool setget _set_fog

func _set_fog(is_fog: bool):
	material.set("shader_param/smogFactor", 0 if is_fog else 1)


func get_size():
	return $Sprite.texture.get_size()


func shake():
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("shake")


# Called when the node enters the scene tree for the first time.
func _ready():
	if siblingpaths.length() > 0:
		for subpath in siblingpaths.split(","):
			var person: Person = get_node(NodePath("../%s" % subpath))
			siblings.push_front(person)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
