extends Control

class_name DialogMaster

signal dialog_signal
signal dialog_end_reached


export (bool) var consume_inputs = true
var _current_dialog_item: DialogItem
var _timer: Timer = Timer.new()
var _text_tween: Tween = Tween.new()
var _showing_text_characters: bool = false
var _audio_player: AudioStreamPlayer
var _rnd = RandomNumberGenerator.new()
onready var text_label: Label = $HBoxContainer/DialogContainer/TextMargin/DialogLabel

func show_dialog(item: DialogItem):
	set_process_input(true)
	if item is TextDialog:
		visible = true
		_current_dialog_item = item
		text_label.text = item.text
		text_label.visible_characters = 0
		var char_count = text_label.text.length()
		var wait_time = char_count * 0.02
		_text_tween.interpolate_property(text_label, "visible_characters", 0, char_count, wait_time, Tween.TRANS_LINEAR)
		_text_tween.start()
		_showing_text_characters = true
#		print("stc true (%f)" % wait_time)
		_timer.wait_time = wait_time
		_timer.connect("timeout", self, "_end_showing_characters", [], CONNECT_ONESHOT)
		_timer.start()
		if item.name != null and item.name.length() > 0:
			GlobalReferences.person_handler.start_talk_person(item.name)
			match item.name:
				"Fiona":
					_audio_player.stream = preload("res://sounds/bit/bit01.wav")
				"Louyse":
					_audio_player.stream = preload("res://sounds/bit/bit02.wav")
				"Stephan":
					_audio_player.stream = preload("res://sounds/bit/bit03.wav")
				"Nyxie":
					_audio_player.stream = preload("res://sounds/bit/bit04.wav")
				"Charles":
					_audio_player.stream = preload("res://sounds/bit/bit05.wav")
				_:
					_audio_player.stream = preload("res://sounds/bit/bit01.wav")
		else:
			_audio_player.stream = preload("res://sounds/bit/bit01.wav")
		if item.portrait != null:
			$HBoxContainer/MarginContainer.visible = true
			$HBoxContainer/MarginContainer/PortraitMargin/PortraitTexture.texture = item.portrait
		else:
			$HBoxContainer/MarginContainer.visible = false
	elif item is WaitDialog:
		visible = false
		_current_dialog_item = item
		_timer.wait_time = item.wait_time
		_timer.connect("timeout", self, "_process_next_dialog", [], CONNECT_ONESHOT)
		_timer.start()
	elif item is SignalDialog:
		_current_dialog_item = item
		emit_signal("dialog_signal") if item.signal_name == null else emit_signal("dialog_signal", item.signal_name)
		_process_next_dialog()
		pass


func _ready():
	GlobalReferences.dialog_master = self
	_audio_player = AudioStreamPlayer.new()
	_audio_player.bus = "talk"
	_rnd.randomize()
	add_child(_audio_player)
	visible = false
	add_child(_timer)
	add_child(_text_tween)
	set_process_input(false)


func _process(_delta):
	if _showing_text_characters and not _audio_player.playing:
		_audio_player.pitch_scale = _rnd.randf_range(0.98, 1.03)
		_audio_player.play()

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if consume_inputs:
			get_tree().set_input_as_handled()
		if _current_dialog_item == null:
			return
		if visible == false:
			return
		if _showing_text_characters:
			_text_tween.stop_all()
			_timer.stop()
			_timer.disconnect("timeout", self, "_end_showing_characters")
			text_label.visible_characters = -1
			_showing_text_characters = false
#			print("stc false")
		else:
			_process_next_dialog()


func _process_next_dialog():
	_current_dialog_item = _current_dialog_item.nextItem
	if _current_dialog_item != null:
		if _current_dialog_item is TextDialog and _current_dialog_item.blink:
			_timer.wait_time = 0.12
			_timer.connect("timeout", self, "show_dialog", [_current_dialog_item], CONNECT_ONESHOT)
			_timer.start()
			visible = false
		else:
			show_dialog(_current_dialog_item)
	else:
		visible = false
		set_process_input(false)
		emit_signal("dialog_end_reached")


func _end_showing_characters():
	_showing_text_characters = false
#	print("stc false")

