extends Node


func play_sound_oneshot(sound: AudioStreamSample):
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = sound
	audio_player.connect("finished", audio_player, "queue_free")
	audio_player.play(0)
