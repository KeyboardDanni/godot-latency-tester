extends Node2D

func _process(_delta: float) -> void:
	var isCapped = (Engine.max_fps > 0);
	var capTarget = Engine.physics_ticks_per_second;
	
	if Input.is_action_just_pressed("toggle_fullscreen"):
		match DisplayServer.window_get_mode():
			DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN, DisplayServer.WINDOW_MODE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
			_:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN);
	
	if Input.is_action_just_pressed("ui_accept"):
		Engine.max_fps = 0 if isCapped else capTarget;
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit();
