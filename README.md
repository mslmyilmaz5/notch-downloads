# Notch Downloads

A small macOS app that hangs under the MacBook notch and shows your **last 5 downloads**.

![Notch Downloads demo](docs/demo.gif)

## Install

### Homebrew

```sh
brew tap mslmyilmaz5/mac-last-downloads https://github.com/mslmyilmaz5/mac-last-downloads
brew trust mslmyilmaz5/mac-last-downloads
brew install --cask notch-downloads
```

Homebrew will not load a cask from a third-party tap until that tap is trusted.

Apple Silicon only (arm64), macOS 13 Ventura or later. The cask installs the latest GitHub release.

On first launch, allow access to your Downloads folder. If you turn on **Show Screenshots Instantly**, macOS also asks for Desktop access.

Uninstall:

```sh
brew uninstall --cask notch-downloads
```

### Direct download

Prebuilt app: **[latest release](https://github.com/mslmyilmaz5/mac-last-downloads/releases/latest)**

| File | Link |
| --- | --- |
| DMG | [NotchDownloads.dmg](https://github.com/mslmyilmaz5/mac-last-downloads/releases/latest/download/NotchDownloads.dmg) |
| ZIP | [NotchDownloads.zip](https://github.com/mslmyilmaz5/mac-last-downloads/releases/latest/download/NotchDownloads.zip) |

Open the DMG or ZIP and drag the app to `/Applications`. The build is not notarized, so the first open is **right-click → Open**. If macOS says the app is damaged:

```sh
xattr -cr /Applications/NotchDownloads.app
```

Then allow access to the Downloads folder.

## Features

- **A thin chin under the notch.** Idle, it reads as part of the notch. Hover highlights it; click expands the list.
- **A short preview** when a new file arrives.
- **The last 5 files**, newest first, with their real icons.
- **Drag and drop.** Drag a row — or the new-file preview, without opening the list — into Finder, Terminal, or any other app.
- **Quick actions** on hover: Show in Finder, Copy, Share, Move to Trash. The same actions are in the right-click menu.
- **Hides partial downloads.** `.download`, `.crdownload`, `.part`, and similar files stay out of the list until the download finishes.
- **Screenshots.** The macOS screenshot folder (Desktop by default) is watched too, and only screenshot and screen-recording files are added. **Show Screenshots Instantly** turns off the system’s floating thumbnail so the capture shows up in the notch the moment you take it. Desktop access is requested for that.
- **English interface.** Menus, the panel, and permission copy are in English.
- **Menu bar icon** to open the panel, launch at login, or quit.
- On displays without a notch (external monitors), the panel sits centered under the menu bar.

## Requirements

- macOS 13 Ventura or later
- Apple Silicon (M1 or later). The release build is `arm64` only
- A Swift toolchain to build from source (Xcode Command Line Tools are enough): `xcode-select --install`

## Run from source

```sh
make run
```

That builds the app, writes `dist/NotchDownloads.app`, and launches it.

The first time, macOS asks to let Notch Downloads read your Downloads folder. Choose **Allow**. If access was denied, use **Open System Settings** inside the panel.

### Skip the permission prompt while developing

The app is ad-hoc signed, so macOS can forget the folder grant on every rebuild. While developing, run it from the terminal instead:

```sh
make dev
```

It inherits the Downloads permission your terminal (Terminal or iTerm) already has, and does not ask again on each build.

## Install from source

```sh
make install   # copies the app to /Applications
```

Then turn on **Launch at Login** from the menu bar icon.

## Uninstall a source install

```sh
make uninstall
```

## Layout

| File | Role |
| --- | --- |
| `DownloadsMonitor.swift` | Watches `~/Downloads` with a `DispatchSource` (vnode) and keeps the last 5 files |
| `ScreenshotSettings.swift` | Screenshot folder and the `show-thumbnail` setting (`com.apple.screencapture`) |
| `NotchGeometry.swift` | Notch frame in screen coordinates (`auxiliaryTopLeftArea` / `safeAreaInsets`) |
| `NotchViewModel.swift` | UI state (chin / preview / list) and file actions |
| `NotchPanelController.swift` | Non-activating `NSPanel` parked under the notch, plus the animations |
| `Views/` | SwiftUI views (list, row, preview) |
| `AppDelegate.swift` | Menu bar icon and launch at login (`SMAppService`) |

Folder access is not sandboxed. TCC asks for Downloads (and Desktop, if screenshots are enabled) on first launch.

## License

[MIT](LICENSE)
