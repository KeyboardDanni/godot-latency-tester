
# Latency Tester for Godot

## How to use

Just set your display's refresh rate to 60hz, run the application, and take a picture of your screen with your phone's camera (or HDMI capture device).

Capture an image, then count how many spaces ahead the Reference is (going to the right, wrapping from right to left), **and add 1**. This should give you the number of frames of lag.

**Important!** For test results to be valid, hardware cursor **must** be enabled and supported by the windowing system, and captures **must** be taken with a hardware camera or HDMI output to capture card. Software capture will produce incorrect results. If V-Sync is off or the refresh rate doesn't match the physics rate, cap the framerate with `Enter` or the test won't make much sense.

Since this test uses the hardware cursor, press `Delete` to ungrab/regrab the cursor.

You may need the window to be in the foreground and unobscured, or some platforms might not perform direct scanout of the image. In cases where direct scanout is not available in windowed mode, record separate measurements in both windowed and fullscreen mode.

## Findings

Note that these were taken on a system with an nVidia RTX 3070 running on Windows 11, with display set to 60hz and VRR disabled. Driver low latency was disabled. You may get different results with a different OS and drivers.

These tests were done without simulated load. You may get different results based on how much work the CPU/GPU is doing. This is something I would like to add testing for in the future.

### Forward+ Vulkan, Layered DXGI (driver-level) Presentation

- `vsync disabled`, `frame_queue_size = 2`, `swapchain_image_count = 3` = **0-1 frames**
- `vsync enabled`, `frame_queue_size = 2`, `swapchain_image_count = 3` = **5 frames**
- `vsync enabled`, `frame_queue_size = 2`, `swapchain_image_count = 2` = **4 frames**
- `vsync enabled`, `frame_queue_size = 1`, `swapchain_image_count = 2` = **3 frames**
- `vsync mailbox`, `frame_queue_size = 2`, `swapchain_image_count = 3` = **1 frame**
- `vsync mailbox`, `frame_queue_size = 2`, `swapchain_image_count = 2` = **4 frames**

### Forward+ Vulkan, Native Presentation, Windowed

- `vsync disabled`, `frame_queue_size = 2`, `swapchain_image_count = 3` = **1-3 frames**
- `vsync enabled`, `frame_queue_size = 2`, `swapchain_image_count = 3` = **2 frames**
- `vsync enabled`, `frame_queue_size = 2`, `swapchain_image_count = 2` = **2 frames**
- `vsync enabled`, `frame_queue_size = 1`, `swapchain_image_count = 2` = **2 frames**
- `vsync mailbox`, `frame_queue_size = 2`, `swapchain_image_count = 3` = **1-3 frames**
- `vsync mailbox`, `frame_queue_size = 2`, `swapchain_image_count = 2` = **1-3 frames**

### Forward+ Vulkan, Native Presentation, Fullscreen

- `vsync disabled`, `frame_queue_size = 2`, `swapchain_image_count = 3` = **0-1 frames**
- `vsync enabled`, `frame_queue_size = 2`, `swapchain_image_count = 3` = **4 frames**
- `vsync enabled`, `frame_queue_size = 2`, `swapchain_image_count = 2` = **3 frames**
- `vsync enabled`, `frame_queue_size = 1`, `swapchain_image_count = 2` = **2 frames**
- `vsync mailbox`, `frame_queue_size = 2`, `swapchain_image_count = 3` = **1-3 frames**
- `vsync mailbox`, `frame_queue_size = 2`, `swapchain_image_count = 2` = **1-3 frames**

### Compatibility OpenGL, Layered DXGI (driver-level) Presentation

- `vsync disabled` = **0-1 frames**
- `vsync enabled` = **2 frames**

### Compatibility OpenGL, Native Presentation, Windowed

- `vsync disabled` = **1-3 frames**
- `vsync enabled` = **2 frames**

### Compatibility OpenGL, Native Presentation, Fullscreen

- `vsync disabled` = **0-1 frames**
- `vsync enabled` = **3 frames**
