cask "notchuser" do
  version "1.8.0"
  sha256 "674756c08686bb869bbf423a226a80c71f8dc7b33de56cec2af07569a7452667"

  url "https://github.com/Magnumja/NotchUser/releases/download/v#{version}/NotchUser.zip"
  name "NotchUser"
  desc "Dynamic Island for the MacBook notch: music, lyrics, file shelf and AI agents"
  homepage "https://github.com/Magnumja/NotchUser"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "NotchUser.app"
  binary "#{appdir}/NotchUser.app/Contents/Resources/notch"

  # The app is open source but not notarized, so Gatekeeper would refuse to open it.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/NotchUser.app"],
        writable_paths: ["{{appdir}}/NotchUser.app"]
  end

  uninstall quit: "io.github.notchuser"

  zap trash: [
    "~/Library/Application Support/NotchUser",
    "~/Library/Caches/NotchUser",
    "~/Library/Preferences/io.github.notchuser.plist",
  ]

  caveats <<~EOS
    NotchUser isn't notarized by Apple, so this cask removes the download
    quarantine flag to let it open. The source is at:
      https://github.com/Magnumja/NotchUser
  EOS
end
