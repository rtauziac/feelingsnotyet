extends YSort

class_name PersonHandler

export (bool) var camera_tracks_dialog = true
onready var mind_probe_audio_player = $MindProbeStreamPlayer
var _current_person: Person = null
var _remove_current_person_at_end_dialog: bool = false
var _tweener: Tween


func focus_person(the_person: Person):
	set_smog_for_person(the_person)
	_set_mind_probe_volume(1)


func start_talk_person(person_name: String):
	var person = get_node_or_null(person_name)
	if person is Person:
		person.talk()
		if camera_tracks_dialog:
			get_parent().get_node("CameraHolder").move_to_position(person.position)


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
	_set_mind_probe_volume(0)


func _ready():
	GlobalReferences.person_handler = self
	set_process_input(false)
	_tweener = Tween.new()
	add_child(_tweener)
	call_deferred("_ready_later")


func _set_mind_probe_volume(vol):
	_tweener.interpolate_property(mind_probe_audio_player, "volume_db", mind_probe_audio_player.volume_db, lerp(-80, 0, vol), 1, Tween.TRANS_LINEAR)
	_tweener.start()

func _ready_later():
	GlobalReferences.dialog_master.connect("dialog_signal", self, "_on_dialog_signal")

func _process_persons():
	var children: Array = get_children()
	for x in children.size():
		var person = children[-x+1]
		if person is Person:
			var local_rect: Rect2 = person.get_rect()
			var person_rect: Rect2 = Rect2(to_global(local_rect.position), local_rect.size)
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
			var sig:
				if sig.begins_with("camera_tracks_dialog:"):
					var ctd = sig.substr(21)
					camera_tracks_dialog = false if ctd == "false" else true
				elif sig.begins_with("camera_focus:"):
					var person_name = sig.substr(13)
					var person = get_node_or_null(person_name)
					if person is Person:
						get_parent().get_node("CameraHolder").move_to_position(person.position)
					


func _focus_current_person():
	focus_person(_current_person)
	var devil: Devil = _current_person.get_node_or_null("Devil")
	if devil != null:
		devil.visible = true
		devil.start_shards()
		set_process_input(false)
