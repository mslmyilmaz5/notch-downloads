APP_NAME    := NotchDownloads
BUILD_DIR   := .build
DIST_DIR    := dist
APP_DIR     := $(DIST_DIR)/$(APP_NAME).app
BINARY      := $(BUILD_DIR)/release/$(APP_NAME)

.PHONY: build app run dev install uninstall package dmg clean

build:
	swift build -c release

## Builds the .app bundle and ad-hoc signs it.
app: build
	@echo "→ Building $(APP_DIR)"
	@rm -rf "$(APP_DIR)"
	@mkdir -p "$(APP_DIR)/Contents/MacOS" "$(APP_DIR)/Contents/Resources"
	@cp "$(BINARY)" "$(APP_DIR)/Contents/MacOS/$(APP_NAME)"
	@cp Resources/Info.plist "$(APP_DIR)/Contents/Info.plist"
	@cp Resources/AppIcon.icns "$(APP_DIR)/Contents/Resources/AppIcon.icns"
	@codesign --force --sign - "$(APP_DIR)" 2>/dev/null || true
	@echo "✓ $(APP_DIR) ready"

## Quits any running copy and launches the app again.
run: app
	@killall $(APP_NAME) 2>/dev/null || true
	@open "$(APP_DIR)"

## Runs from the terminal during development so it inherits the terminal's
## Downloads permission and does not ask again on every build.
dev: build
	@killall $(APP_NAME) 2>/dev/null || true
	@"$(BINARY)"

## Copies the app into /Applications.
install: app
	@cp -R "$(APP_DIR)" /Applications/
	@echo "✓ Installed /Applications/$(APP_NAME).app"

## Builds a zip for distribution (dist/NotchDownloads.zip).
package: app
	@rm -f "$(DIST_DIR)/$(APP_NAME).zip"
	@ditto -c -k --sequesterRsrc --keepParent "$(APP_DIR)" "$(DIST_DIR)/$(APP_NAME).zip"
	@echo "✓ $(DIST_DIR)/$(APP_NAME).zip ready"

## Builds a DMG for distribution (dist/NotchDownloads.dmg, with an Applications shortcut).
dmg: app
	@rm -rf "$(DIST_DIR)/dmg-staging" "$(DIST_DIR)/$(APP_NAME).dmg"
	@mkdir -p "$(DIST_DIR)/dmg-staging"
	@cp -R "$(APP_DIR)" "$(DIST_DIR)/dmg-staging/"
	@ln -s /Applications "$(DIST_DIR)/dmg-staging/Applications"
	@hdiutil create -volname "$(APP_NAME)" -srcfolder "$(DIST_DIR)/dmg-staging" -ov -format UDZO "$(DIST_DIR)/$(APP_NAME).dmg" >/dev/null
	@rm -rf "$(DIST_DIR)/dmg-staging"
	@echo "✓ $(DIST_DIR)/$(APP_NAME).dmg ready"

uninstall:
	@killall $(APP_NAME) 2>/dev/null || true
	@rm -rf "/Applications/$(APP_NAME).app"
	@echo "✓ Removed"

clean:
	@rm -rf "$(BUILD_DIR)" "$(DIST_DIR)"
