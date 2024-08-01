extends Label

const VSYNC_NAMES = [
	"disabled",
	"enabled",
	"adaptive",
	"mailbox"
];

const WINDOWED_MODE_NAMES = [
	"windowed",
	"minimized",
	"maximized",
	"indirect fullscreen",
	"direct fullscreen"
];

func _process(_delta: float) -> void:
	var renderingDevice = RenderingServer.get_rendering_device();
	var vsyncMode = DisplayServer.window_get_vsync_mode();
	var windowMode = DisplayServer.window_get_mode();
	var refreshRate = DisplayServer.screen_get_refresh_rate();
	var frameQueueSize = ProjectSettings.get_setting("rendering/rendering_device/vsync/frame_queue_size", NAN);
	var swapchainCount = ProjectSettings.get_setting("rendering/rendering_device/vsync/swapchain_image_count", NAN);
	
	text = "V-Sync: {vsyncMode} ({vsyncName}) | Mode: {windowMode} ({windowModeName}) | Refresh rate: {refreshRate} hz".format({
		"vsyncMode": vsyncMode,
		"vsyncName": VSYNC_NAMES[vsyncMode],
		"windowMode": windowMode,
		"windowModeName": WINDOWED_MODE_NAMES[windowMode],
		"refreshRate": "%0.2f" % refreshRate
	});
	
	if renderingDevice:
		text += " | frame_queue_size = {frameQueueSize} | swapchain_image_count = {swapchainCount}".format({
			"frameQueueSize": frameQueueSize,
			"swapchainCount": swapchainCount
		});
	else:
		text += " | frame queue/swapchain settings unavailable";
