extends ViewportContainer

class_name PostEffectManager


enum ColorScheme {MARINE, DARK_RED}


export (GradientTexture) var marine_scheme
export (GradientTexture) var dark_red_scheme

var color_scheme: int = ColorScheme.MARINE

var _tweener: Tween


func set_color_scheme(_scheme: int):
	var _c_s: GradientTexture = null
	match _scheme:
		ColorScheme.MARINE:
			_c_s = marine_scheme
		ColorScheme.DARK_RED:
			_c_s = dark_red_scheme
	if _c_s != null:
		material.set("shader_param/ColorRamp", material.get("shader_param/ColorRamp2"))
		material.set("shader_param/rampFade", 0)
		material.set("shader_param/ColorRamp2", _c_s)
		_tweener.interpolate_property(material, "shader_param/rampFade", 0, 1, 1, Tween.TRANS_LINEAR)
		_tweener.start()


func set_vignette_factor(factor: float):
	_tweener.interpolate_property(material, "shader_param/vignetteFactor", material.get("shader_param/vignetteFactor"), factor, 1, Tween.TRANS_LINEAR)
	_tweener.start()

func _ready():
	GlobalReferences.post_effect_manager = self
	_tweener = Tween.new()
	add_child(_tweener)
	call_deferred("_ready_later")


func _ready_later():
	GlobalReferences.dialog_master.connect("dialog_signal", self, "_on_dialog_signal")


func _on_dialog_signal(dialog_signal: String):
	if dialog_signal.begins_with("color_scheme:"):
		var scheme_name = dialog_signal.substr(13)
		var scheme = null
		match scheme_name:
			"marine":
				scheme = ColorScheme.MARINE
			"dark_red":
				scheme = ColorScheme.DARK_RED
		if scheme != null:
			set_color_scheme(scheme)
	elif dialog_signal.begins_with("vignette_factor:"):
		var vignette_factor = float(dialog_signal.substr(16))
		set_vignette_factor(vignette_factor)
