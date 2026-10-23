cask "notch-downloads" do
  version "1.2.1"
  sha256 "d8a2e0c53e2715679ed2178789ce3ca88719be27563909cd6f5c708905def2bf"

  url "https://github.com/mslmyilmaz5/notch-downloads/releases/download/v#{version}/NotchDownloads.dmg"
  name "Notch Downloads"
  desc "Show recent downloads under the MacBook notch"
  homepage "https://github.com/mslmyilmaz5/notch-downloads"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"
  depends_on arch: :arm64

  app "NotchDownloads.app"

  postflight do
    # Ad-hoc signed, so Gatekeeper reports the app as damaged while quarantined.
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/NotchDownloads.app"]
  end

  uninstall quit: "com.mdp.notchdownloads"

  zap trash: "~/Library/Preferences/com.mdp.notchdownloads.plist"
end
