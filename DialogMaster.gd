extends Control

class_name DialogMaster

signal dialog_signal
signal dialog_end_reached


var _current_dialog_item: DialogItem
var _timer: Timer = Timer.new()
var _text_tween: Tween = Tween.new()
onready var text_label: Label = $HBoxContainer/DialogContainer/TextMargin/DialogLabel

func show_dialog(item: DialogItem):
	if item is TextDialog:
		visible = true
		_current_dialog_item = item
		text_label.text = item.text
		text_label.visible_characters = 0
		var char_count = text_label.text.length()
		_text_tween.interpolate_property(text_label, "visible_characters", 0, char_count, char_count * 0.02, Tween.TRANS_LINEAR)
		_text_tween.start()
		if item.portrait != null:
			$HBoxContainer/MarginContainer.visible = true
			$HBoxContainer/MarginContainer/PortraitMargin/PortraitTexture.texture = item.portrait
		else:
			$HBoxContainer/MarginContainer.visible = false
	elif item is WaitDialog:
		visible = false
		_timer.wait_time = item.wait_time
		_timer.connect("timeout", self, "_process_next_dialog", [], CONNECT_ONESHOT)
		_timer.start()


func _ready():
	GlobalReferences.dialog_master = self
	visible = false
	add_child(_timer)
	add_child(_text_tween)


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		get_tree().set_input_as_handled()
		if _current_dialog_item == null:
			return
		if visible == false:
			return
		if _text_tween.is_active():
			_text_tween.stop_all()
			text_label.visible_characters = -1
		else:
			_process_next_dialog()


func _process_next_dialog():
	_current_dialog_item = _current_dialog_item.nextItem
	if _current_dialog_item != null:
		if _current_dialog_item is TextDialog and _current_dialog_item.blink:
			_timer.wait_time = 0.2
			_timer.connect("timeout", self, "show_dialog", [_current_dialog_item], CONNECT_ONESHOT)
			_timer.start()
			visible = false
		else:
			show_dialog(_current_dialog_item)
	else:
		visible = false
		set_process_input(false)
		emit_signal("dialog_end_reached")
