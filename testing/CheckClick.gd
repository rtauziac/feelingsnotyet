extends YSort

class_name PersonHandler

var _current_person: Person = null
var _remove_current_person_at_end_dialog: bool = false
var _speech01 = preload("res://sounds/speech1.wav")
var _speech02 = preload("res://sounds/speech2.wav")
var _speech03 = preload("res://sounds/speech3.wav")
var _speech04 = preload("res://sounds/speech4.wav")
var _speech05 = preload("res://sounds/speech5.wav")
var _speech06 = preload("res://sounds/speech6.wav")


func focus_person(the_person: Person):
	set_smog_for_person(the_person)


func start_talk_person(person_name: String):
	match person_name:
		"Nyxie":
			$AudioStreamPlayer.stream = _speech01
		"Stephan":
			$AudioStreamPlayer.stream = _speech02
		"Fiona":
			$AudioStreamPlayer.stream = _speech03
		"Charles":
			$AudioStreamPlayer.stream = _speech05
		"Louyse":
			$AudioStreamPlayer.stream = _speech04
		_:
			$AudioStreamPlayer.stream = _speech06
	$AudioStreamPlayer.play(0)
	var person = get_node_or_null(person_name)
	if person is Person:
		person.talk()


func set_smog_for_person(the_person: Person):
	var all_friends: Array = the_person.siblings
	for person in get_children():
		if person is Person:
			var is_friend = all_friends.has(person)
			var is_self = person == the_person
			person.fog = not (is_friend or is_self)


func remove_smog():
		for person in get_children():
			if person is Person:
				person.fog = false


func _ready():
	GlobalReferences.person_handler = self
	set_process_input(false)
	call_deferred("_ready_later")

func _ready_later():
	GlobalReferences.dialog_master.connect("dialog_signal", self, "_on_dialog_signal")

func _process_persons():
	var children: Array = get_children()
	for x in children.size():
		var person = children[-x+1]
		if person is Person:
			var person_rect: Rect2 = Rect2(to_global(person.position), person.get_size())
			if person_rect.has_point(get_global_mouse_position()):
				var focused: bool = _current_person != null
				var is_self: bool = person == _current_person
				var sibling = _current_person.siblings.has(person) if _current_person != null else false
				var focusable: bool = true if is_self else (sibling if focused else person.is_open)
				var has_open_dialog: bool = person.open_dialog != null
				var has_close_dialog: bool = person.close_dialog != null
				if focusable:
					_current_person = person
					if has_open_dialog:
						GlobalReferences.dialog_master.connect("dialog_end_reached", self, "_dialog_did_end", [], CONNECT_ONESHOT)
						GlobalReferences.dialog_master.show_dialog(person.open_dialog)
					else:
						_focus_current_person()
					get_tree().set_input_as_handled()
					break
				else:
					if not focused and has_close_dialog:
						_current_person = person
						_remove_current_person_at_end_dialog = true
						GlobalReferences.dialog_master.connect("dialog_end_reached", self, "_dialog_did_end", [], CONNECT_ONESHOT)
						GlobalReferences.dialog_master.show_dialog(person.close_dialog)
						get_tree().set_input_as_handled()
						break
	if not get_tree().is_input_handled():
		get_tree().set_input_as_handled()
		_current_person = null
		remove_smog()


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			if _current_person != null and _current_person.get_node("Devil") != null:
				return
			else:
				_process_persons()


func _dialog_did_end():
	if _remove_current_person_at_end_dialog:
		_remove_current_person_at_end_dialog = false
		_current_person = null


func _on_dialog_signal(signal_name):
	if signal_name is String:
		match signal_name:
			"focus_current_person":
				_focus_current_person()


func _focus_current_person():
	focus_person(_current_person)
	var devil: Devil = _current_person.get_node_or_null("Devil")
	if devil != null:
		devil.visible = true
		devil.start_shards()
		set_process_input(false)
