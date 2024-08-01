extends Label

func _process(_delta: float) -> void:
	var deviceName = RenderingServer.get_video_adapter_name();
	var backend = "Compatibility";
	var renderingDevice = RenderingServer.get_rendering_device();
	
	if renderingDevice:
		deviceName = renderingDevice.get_device_name();
		backend = "RenderingDevice";
	
	text = "Device: {deviceName} | {backend}".format({
		"backend": backend,
		"deviceName": deviceName
	});
