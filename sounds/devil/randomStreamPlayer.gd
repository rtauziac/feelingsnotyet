extends AudioStreamPlayer


export (Array, AudioStream) var audio_list: Array
export (float, 0, 1) var pitch_variation = 0
var _audio_index = 0
var _random = RandomNumberGenerator.new()


func _ready():
	_random.randomize()


func play_sound():
	if audio_list.size() > 0:
		stream = audio_list[_audio_index]
		pitch_scale = _random.randf_range(1 - 0.5 * pitch_variation, 1 + pitch_variation)
		_audio_index = _audio_index + 1 if _audio_index < audio_list.size() - 1 else 0
		play(0)
