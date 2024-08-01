extends Label

func _process(_delta: float) -> void:
	var fps = snappedf(Engine.get_frames_per_second(), 0.01);
	var isCapped = (Engine.max_fps > 0);
	var capTarget = Engine.physics_ticks_per_second;
	
	text = "{fps} fps | {isCapped}, [Enter] to toggle".format({
		"fps": fps,
		"isCapped": "capped at {0}".format([capTarget]) if isCapped else "uncapped"
	});
