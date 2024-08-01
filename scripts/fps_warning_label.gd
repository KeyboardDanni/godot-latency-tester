extends Label

func _process(_delta: float) -> void:
	var fps = Engine.get_frames_per_second();
	var capTarget = Engine.physics_ticks_per_second;
	
	if fps > capTarget * 1.02:
		text = "FPS too high! Please cap framerate!";
	elif fps < capTarget * 0.95:
		text = "Low FPS";
	else:
		text = "";
	
