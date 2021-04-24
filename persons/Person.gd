extends Node2D

class_name Person, "res://editor/icons/dog.png"


export (Array, NodePath) var siblingpaths
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
	for path in siblingpaths:
		var person: Person = get_node(path)
		siblings.push_front(person)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
