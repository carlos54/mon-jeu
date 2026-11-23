class_name SafeAreaContainer
extends MarginContainer
## Conteneur qui applique les zones sûres (encoche, coins arrondis, barre de
## geste) sous forme de marges. Mettez-le à la racine de chaque écran UI.


func _ready() -> void:
	get_viewport().size_changed.connect(_apply_safe_area)
	_apply_safe_area()


func _apply_safe_area() -> void:
	# Sur ordinateur, la "zone sûre" est celle de l'écran, pas de la fenêtre :
	# on ne l'applique que sur mobile.
	if not OS.has_feature("mobile"):
		_set_margins(0, 0, 0, 0)
		return

	var safe: Rect2i = DisplayServer.get_display_safe_area()
	var window_size: Vector2i = DisplayServer.window_get_size()
	if safe.size == Vector2i.ZERO or window_size.x <= 0 or window_size.y <= 0:
		_set_margins(0, 0, 0, 0)
		return

	# Pixels physiques -> coordonnées du viewport (stretch canvas_items).
	var ratio: Vector2 = get_viewport_rect().size / Vector2(window_size)
	_set_margins(
		roundi(maxi(0, safe.position.x) * ratio.x),
		roundi(maxi(0, safe.position.y) * ratio.y),
		roundi(maxi(0, window_size.x - safe.end.x) * ratio.x),
		roundi(maxi(0, window_size.y - safe.end.y) * ratio.y),
	)


func _set_margins(left: int, top: int, right: int, bottom: int) -> void:
	add_theme_constant_override("margin_left", left)
	add_theme_constant_override("margin_top", top)
	add_theme_constant_override("margin_right", right)
	add_theme_constant_override("margin_bottom", bottom)
