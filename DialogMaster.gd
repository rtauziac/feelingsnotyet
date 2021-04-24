extends Control

class_name DialogMaster

signal dialog_signal
signal dialog_end_reached


var _current_dialog_item: DialogItem


func show_dialog(item: DialogItem):
	if item is TextDialog:
		visible = true
		_current_dialog_item = item
		$HBoxContainer/DialogContainer/TextMargin/DialogLabel.text = item.text
		if item.portrait != null:
			$HBoxContainer/MarginContainer.visible = true
			$HBoxContainer/MarginContainer/PortraitMargin/PortraitTexture.texture = item.portrait
		else:
			$HBoxContainer/MarginContainer.visible = false


func _ready():
	GlobalReferences.dialog_master = self
	visible = false


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		get_tree().set_input_as_handled()
		if _current_dialog_item == null:
			return
		_current_dialog_item = _current_dialog_item.nextItem
		if _current_dialog_item != null:
			show_dialog(_current_dialog_item)
		else:
			visible = false
			set_process_input(false)
			emit_signal("dialog_end_reached")
