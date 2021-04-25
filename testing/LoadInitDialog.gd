extends Node2D


export (Resource) var dialog_start


func _ready():
	var a_timer = Timer.new()
	add_child(a_timer)
	if dialog_start == null:
		_enable_game_input()
	else:
		a_timer.wait_time = 2
		a_timer.connect("timeout", self, "_load_first_dialog", [], CONNECT_ONESHOT)
		a_timer.start()


func _load_first_dialog():
	GlobalReferences.dialog_master.show_dialog(dialog_start)
	GlobalReferences.dialog_master.connect("dialog_end_reached", self, "_enable_game_input", [], CONNECT_ONESHOT)


func _enable_game_input():
	$Persons.set_process_input(true)
