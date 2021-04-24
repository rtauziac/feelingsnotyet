extends Node2D

class_name Devil, "res://editor/icons/devil.png"

signal hurt


export (PackedScene) var shardScene
export (int) var lives = 3
var _shard: Sprite = null
var _current_shard: Sprite = null
var _tweener: Tween
var _timer: Timer
var _rotate_amount = 0


func start_shards():
	set_process(true)
	_timer.wait_time = 3
	_timer.connect("timeout", self, "_create_shard", [3], CONNECT_ONESHOT)
	_timer.start()
	connect("hurt", get_parent(), "shake")


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	visible = false
	_tweener = Tween.new()
	add_child(_tweener)
	_timer = Timer.new()
	add_child(_timer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _current_shard != null:
		_shard.rotate(_rotate_amount)


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if _current_shard != null:
			lives -= 1
			_tweener.stop_all()
			_timer.disconnect("timeout", self, "emit_hurt")
			_timer.stop()
			var anim_len = 0.3
			_fade_out(anim_len)
			if lives > 0:
				_timer.wait_time = anim_len
				_timer.connect("timeout", self, "_destroy_then_create_new_shard", [], CONNECT_ONESHOT)
				_timer.start()
			else:
				_tweener.interpolate_property(self, "modulate", Color.white, Color(1, 1, 1, 0), 3)
				_tweener.start()
				_timer.wait_time = 5
				_timer.connect("timeout", self, "queue_free", [], CONNECT_ONESHOT)
				_timer.start()


func _create_shard(duration):
	var new_shard: Sprite = shardScene.instance()
	add_child(new_shard)
	_shard = new_shard
	_current_shard = _shard
	new_shard.rotation = randf() * 2 * PI
	_shard.modulate = Color(1, 1, 1, 0)
	_tweener.interpolate_property(_shard, "modulate", Color(1, 1, 1, 0), Color.white, 0.5,Tween.TRANS_LINEAR)
	_tweener.interpolate_property(self, "_rotate_amount", PI/20, 0, duration, Tween.TRANS_LINEAR)
	_tweener.start()
	_timer.wait_time = duration
	_timer.connect("timeout", self, "emit_hurt", [], CONNECT_ONESHOT)
	_timer.start()


func emit_hurt():
	emit_signal("hurt")
	var anim_len = 0.3
	_fade_out(anim_len)
	_timer.wait_time = anim_len
	_timer.connect("timeout", self, "_destroy_then_create_new_shard", [], CONNECT_ONESHOT)
	_timer.start()


func _fade_out(anim_len):
	_current_shard = null
	_tweener.interpolate_property(_shard, "modulate", Color.white, Color(1, 1, 1, 0), anim_len, Tween.TRANS_LINEAR)
	_tweener.interpolate_property(_shard, "scale", Vector2.ONE, Vector2(2, 2), anim_len, Tween.TRANS_LINEAR)	
	_tweener.start()


func _destroy_then_create_new_shard():
	_shard.queue_free()
	_shard = null
	_timer.wait_time = 3
	_timer.connect("timeout", self, "_create_shard", [3], CONNECT_ONESHOT)
	_timer.start()
