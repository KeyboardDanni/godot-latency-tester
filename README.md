
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

### Forward+ D3D12

- `vsync disabled`, `frame_queue_size = 2`, `swapchain_image_count = 3` = **0-1 frames**
- `vsync enabled`, `frame_queue_size = 2`, `swapchain_image_count = 3` = **4 frames**
- `vsync enabled`, `frame_queue_size = 2`, `swapchain_image_count = 2` = **3 frames**
- `vsync enabled`, `frame_queue_size = 1`, `swapchain_image_count = 2` = **2 frames**

### Compatibility OpenGL, Layered DXGI (driver-level) Presentation

- `vsync disabled` = **0-1 frames**
- `vsync enabled` = **2 frames**
- `vsync enabled`, `glfinish` = **2 frames**

### Compatibility OpenGL, Native Presentation, Windowed

- `vsync disabled` = **1-3 frames**
- `vsync enabled` = **2 frames**
- `vsync enabled`, `glfinish` = **2 frames**

### Compatibility OpenGL, Native Presentation, Fullscreen

- `vsync disabled` = **0-1 frames**
- `vsync enabled` = **3 frames**
- `vsync enabled`, `glfinish` = **1 frame**

## Summary of findings

- nVidia's layered DXGI driver option adds one frame of latency
  - Though this is masked somewhat: `glFinish` only seems to have a noticeable impact when using Native Presentation fullscreen
- Even in the best case scenario (no layered DXGI, `frame_queue_size = 1`), neither Vulkan nor D3D12 can beat OpenGL, with the exception of Vulkan running with `vsync mailbox`.
- For some reason, Vulkan with `vsync mailbox` only seems to work correctly with layered DXGI

## Measurements by other users

- <https://chat.godotengine.org/channel/rendering/thread/9cwuxShgya9jDzXB2>
- <https://github.com/godotengine/godot/pull/94973#issuecomment-2265610604>

### MacBook Pro M3 Max

Tested with Forward+ Metal (MoltenVK)

- `vsync enabled`, `frame_queue_size = 2`, `swapchain_image_count = 3` = **3 frames**

### Windows, Intel UHD Graphics 620

All tests are with `vsync enabled`, `frame_queue_size = 2`, `swapchain_image_count = 3`

- Vulkan, windowed, no waitable swapchain = **6 frames**
- Vulkan, fullscreen, no waitable swapchain = **4 frames**
- D3D12, no waitable swapchain = **4 frames**
- D3D12, waitable swapchain = **2 frames**
- OpenGL, windowed, no waitable swapchain = **3 frames**
- OpenGL, windowed, waitable swapchain = **2 frames**

### Windows, nVidia Optimus: GeForce MX150 on top of Intel UHD Graphics 620

- D3D12, windowed = **8 frames**

### X11 (KWin), Intel HD Graphics 5500

All tests are with Vulkan, `vsync enabled`, `frame_queue_size = 2`, `swapchain_image_count = 3`

- compositing enabled, windowed, no present wait = **6 frames**
- compositing enabled, windowed, present wait = **3 frames**
- compositing disabled, windowed, no present wait = **4 frames**
- compositing disabled, windowed, present wait = **2 frames**
- compositing disabled, fullscreen, no present wait = **2 frames**
- compositing disabled, fullscreen, present wait = **1 frame**

## Results summary so far (FIFO vsync only)

Not all of these were tested with a different frame queue size.

Wayland stats are unavailable as Godot currently has no way to warp the mouse cursor on that platform.

Contributions welcome to help fill in missing data!

1 frame is excellent, 2 frames is great, 3 frames is okay, 4 or more frames is inadequate.

| Platform, GPU Vendor, Backend | Worst Latency | Best Latency (current Godot) | Best Latency (pending improvements) | Notes                                                   |
| ----------------------------- | ------------- | ---------------------------- | ----------------------------------- | ------------------------------------------------------- |
| Windows, nVidia, Vulkan       | **5 frames**  | **3 frames**                 | **2 frames**                        | 2 frames with Native windowed or `frame_queue_size = 1` |
| Windows, nVidia, D3D12        | **4 frames**  | **3 frames**                 | **2 frames**                        | 2 frames with `frame_queue_size = 1`                    |
| Windows, nVidia, OpenGL       | **3 frames**  | **2 frames**                 | **1 frame**                         | 1 frame with `glfinish` and Native Presentation         |
| Windows, AMD, Vulkan          | ???           | ???                          | ???                                 |                                                         |
| Windows, AMD, D3D12           | ???           | ???                          | ???                                 |                                                         |
| Windows, AMD, OpenGL          | ???           | ???                          | ???                                 |                                                         |
| Windows, Intel, Vulkan        | **6 frames**  | **4 frames**                 | ???                                 | tentative, fullscreen required                          |
| Windows, Intel, D3D12         | **4 frames**  | **4 frames**                 | **2 frames**                        | tentative, 2 frames with waitable swapchain             |
| Windows, Intel, OpenGL        | **3 frames?** | **3 frames**                 | **2 frames?**                       | tentative, 2 frames with waitable swapchain             |
| X11, nVidia, OpenGL           | ???           | ???                          | ???                                 |                                                         |
| X11, nVidia, Vulkan           | ???           | ???                          | ???                                 |                                                         |
| X11, AMD, OpenGL              | ???           | ???                          | ???                                 |                                                         |
| X11, AMD, Vulkan              | ???           | ???                          | ???                                 |                                                         |
| X11, Intel, OpenGL            | ???           | ???                          | ???                                 |                                                         |
| X11, Intel, Vulkan            | **6 frames**  | **2 frames**                 | **1 frame**                         | fullscreen required, 1 frame with present wait          |
| Apple, macOS, MoltenVK        | ???           | **3 frames**                 | ???                                 | tentative                                               |

## Low latency enhancements tracker

- [ ] Low latency mode
  - [ ] RenderingDevice
  - [ ] Compatibility
- [ ] Extraneous semaphore wait on swapchain - might be fixed by <https://github.com/godotengine/godot/pull/99257>
- [ ] Waitable swapchains
  - [ ] D3D12 - <https://github.com/godotengine/godot/pull/94960>
  - [ ] Vulkan - <https://github.com/godotengine/godot/pull/94973>
  - [ ] OpenGL
- [ ] Direct use of DXGI on Windows
  - [x] D3D12 (this one's a given)
  - [ ] Vulkan - <https://github.com/DarioSamo/godot/tree/vulkan_dxgi>
  - [ ] OpenGL - <https://github.com/godotengine/godot/pull/94503>
