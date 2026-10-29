# VanishCam — webcam disappearance effects

Video is processed on your computer. It is neither recorded nor sent to a server. The preview window and virtual camera show only the video and effects, without overlaid menus, instructions, or text.

For step-by-step instructions in English and Italian, see the [user guide](USER_GUIDE_EN_IT.md).

## ☕ Buy me a coffee

If you like this project and want to support it, you can buy me a coffee through [PayPal](https://paypal.me/nicovic17) or [Revolut](https://revolut.me/nicoauriemma).

## Download for Windows

[Download VanishCam.exe]( https://nicoaauriemma.vercel.app/shop ) and double-click it to run the app. You do not need to install Python.

The published EXE may predate the Particles and Goku modes. To use them now, run the local scripts or rebuild the EXE from these sources.

## Running on macOS

Works on Apple Silicon and Intel Macs (macOS 11 or later).

1. Install Python 3.10–3.13 if you don't have it: `brew install python@3.12` (or the installer from [python.org](https://www.python.org/downloads/macos/)). The Python that ships with Xcode is too old.
2. Double-click `start_macos.command`, or run it from Terminal:

   ```bash
   ./start_macos.command                      # menu
   ./start_macos.command --mode naruto        # skip the menu
   ./start_macos.command --no-virtual-camera  # preview window only
   ```

   The first run creates `.venv-local/` and installs the dependencies (internet needed once). Intel Macs automatically use `requirements-macos-intel.txt`, because mediapipe 1.x has no Intel macOS build.
3. The first time, macOS asks whether Terminal may use the camera. Click **OK**, then quit Terminal (`Cmd+Q`) and start the script again. If you clicked **Don't Allow**, turn Terminal on in **System Settings → Privacy & Security → Camera**.

Troubleshooting:

- **"start_macos.command can't be opened"** (downloaded as a ZIP rather than cloned): run `chmod +x start_macos.command` in Terminal, then right-click the file and choose **Open**.
- **Wrong camera** (for example your iPhone via Continuity Camera): try `--camera 1`.
- **Virtual camera for Zoom/Meet/FaceTime:** install [OBS Studio](https://obsproject.com/) 30 or later, open it once and click **Start Virtual Camera** so macOS installs the camera extension (approve it in System Settings if asked), then click **Stop Virtual Camera** and quit OBS. VanishCam then sends its output to **OBS Virtual Camera**; select that camera in the other app. Unity Capture is Windows-only.
- `BUILD_WINDOWS.bat` and the `.bat` launchers are Windows-only; on macOS you run the script directly, no build step needed.

## Getting started

1. Double-click `AVVIA_LOCALE.bat`.
2. In the start menu, choose **Normal Vanish**, **Naruto Vanish**, **Particles**, or **Goku** with the mouse or the `1`, `2`, `3`, and `4` keys.
3. Step out of the camera frame for 4 seconds while the background is captured. The terminal tells you when you can step back in.

**Normal Vanish:** Raise your index and middle fingers in a V sign. The dissolve starts as soon as the gesture is recognized and lasts about 3.6 seconds.

**Particles:** Make the same V sign as in Normal Vanish. Your silhouette breaks into small colored fragments that drift sideways as if carried by the wind. The effect lasts about 2.1 seconds. It captures your silhouette once when the effect starts to keep the video smooth.

**Goku:** Hold your index and middle fingers straight and together against your forehead for 1 second. Animated vertical comic-style lines run across your silhouette just before you teleport away and linger briefly afterward. To reappear, lower your hand, then repeat the gesture for another 1 second. The return uses the reverse effect. If you break the pose, the countdown starts over. `assets/teleport.MP3` plays on both disappearance and reappearance. The terminal shows the countdown for each gesture. The `V` and `R` keys are disabled in this mode: the gesture is the only way to disappear and reappear. No text is overlaid on the video.

**Naruto Vanish:** Bring your palms together in front of the webcam, with your fingers side by side rather than interlaced. Keep both hands visible. As soon as the gesture is recognized, you vanish in a cloud of smoke and a wooden log appears, falls, and remains visible until you press `R`. No microphone is needed. Naruto mode uses `hand_landmarker.task` to track both hands. `assets/vanish.MP3` plays through your computer speakers when the disappearance starts, including when triggered with `V`. You can trigger it again after pressing `R`.

To start a mode without the menu:

```powershell
local_app\AVVIA_LOCALE.bat --mode naruto
local_app\AVVIA_LOCALE.bat --mode normal
local_app\AVVIA_LOCALE.bat --mode particles
local_app\AVVIA_LOCALE.bat --mode goku
```

## Virtual camera and OBS

If [OBS Studio](https://obsproject.com/) is installed, the app automatically tries to open **OBS Virtual Camera**. The terminal shows the device name. Use `AVVIA_VIRTUAL.bat` to require a virtual camera. Select **OBS Virtual Camera** in the app that will receive the video. OBS's virtual camera must be stopped while this app is producing its output.

To use the effect in an OBS scene, run `AVVIA_OBS.bat`, add a **Window Capture** source, select **Webcam - Anteprima**, and then start the virtual camera from OBS. Alternatively, use [Unity Capture](https://github.com/schellingb/UnityCapture) as a separate virtual video source:

```powershell
local_app\AVVIA_VIRTUAL.bat --virtual-backend unitycapture
```

OBS has only one virtual camera. Do not use it as both an OBS input and output at the same time. See the [pyvirtualcam documentation](https://github.com/letmaik/pyvirtualcam#supported-virtual-cameras).

## Controls

- `SPACE`: capture a new background.
- `R`: make the person reappear.
- `V`: manually start the selected mode's effect.
- `F`: toggle fullscreen.
- `Q` or `ESC`: quit and release the cameras.

The `V` and `R` keys are disabled in Goku mode.

You can change the camera, resolution, and maximum virtual-output FPS:

```powershell
local_app\AVVIA_LOCALE.bat --camera 1 --width 1280 --height 720 --fps 30
```

To troubleshoot gesture recognition without adding text to the video, pass `--gesture-debug`. Diagnostic information appears only in the terminal.

## Visual assets

The [wooden log](assets/substitution_log.png) is an original illustration generated with ImageGen using the supplied image as a visual reference. Smoke is drawn in real time by `naruto_effect.py` so it follows the person's position and scales with the video. We also considered a [CC0 smoke sprite sheet](https://opengameart.org/content/smoke-sprite-sheet), but the procedural animation adapts better to dynamic positioning without an additional asset. No anime frames or assets are included in the project.

Goku mode uses the [MediaPipe BlazeFace short-range model](https://github.com/google-ai-edge/mediapipe/blob/master/mediapipe/tasks/web/vision/README.md) to estimate the forehead position and `hand_landmarker.task` to track the fingers. The teleport's visual trace is drawn in code, without anime frames.
