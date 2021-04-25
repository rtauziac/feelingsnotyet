extends Control


var _game_scene = preload("res://testing/GameRoot.tscn")


func _on_Play_pressed():
	GlobalReferences.fade_screen.connect("fade_did_finish", self, "_on_fade_end", [], CONNECT_ONESHOT)
	GlobalReferences.fade_screen.fade_to_color(Color.black)


func _on_fade_end():
	get_tree().change_scene_to(_game_scene)
