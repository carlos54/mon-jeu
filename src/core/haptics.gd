class_name Haptics
extends RefCounted
## Vibrations, respectueuses du réglage utilisateur.
## Android : nécessite la permission VIBRATE (activée dans export_presets.cfg).


static func vibrate(duration_ms: int = 30) -> void:
	if SettingsManager.vibration_enabled and OS.has_feature("mobile"):
		Input.vibrate_handheld(duration_ms)
