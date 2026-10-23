cask "notch-downloads" do
  version "1.2.0"
  sha256 "8f5af679c7b6949131e81f0b8c3482bff764254020552e89870ee8d33a24b1fa"

  url "https://github.com/mslmyilmaz5/mac-last-downloads/releases/download/v#{version}/NotchDownloads.dmg"
  name "Notch Downloads"
  desc "Show recent downloads under the MacBook notch"
  homepage "https://github.com/mslmyilmaz5/mac-last-downloads"

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
