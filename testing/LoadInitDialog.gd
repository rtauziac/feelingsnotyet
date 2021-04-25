extends Node2D


export (Resource) var dialog_start
var _credits = preload("res://testing/EndRoot.tscn")

func _ready():
	var a_timer = Timer.new()
	add_child(a_timer)
	if dialog_start == null:
		_enable_game_input()
	else:
		a_timer.wait_time = 2
		a_timer.connect("timeout", self, "_load_first_dialog", [], CONNECT_ONESHOT)
		a_timer.start()
	call_deferred("_start_screen_fade")

func _start_screen_fade():
	GlobalReferences.fade_screen.fade_to_color(Color(0, 0, 0, 0))


func _load_first_dialog():
	GlobalReferences.dialog_master.show_dialog(dialog_start)
	GlobalReferences.dialog_master.connect("dialog_end_reached", self, "_enable_game_input", [], CONNECT_ONESHOT)
	GlobalReferences.dialog_master.connect("dialog_signal", self, "_on_dialog_signal")


func _enable_game_input():
	$Persons.set_process_input(true)


func _on_dialog_signal(signal_name: String):
	if signal_name is String:
		match signal_name:
			"load_level_02":
				GlobalReferences.fade_screen.connect("fade_did_finish", self, "_on_fade_ended", [], CONNECT_ONESHOT)
				GlobalReferences.fade_screen.fade_to_color(Color.black)


func _on_fade_ended():
	get_tree().change_scene_to(_credits)
