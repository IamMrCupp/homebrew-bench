cask "bench-parts" do
  version "0.5.0"
  sha256 "fb4e0a2ebdc19ef39dcb97150ad2be11524ca9e7ccbc2ad147cd34bb4bea8f79"

  url "https://github.com/IamMrCupp/bench-parts/releases/download/v#{version}/bench-parts-#{version}.dmg"
  name "bench parts"
  desc "Menu-bar app that runs the parts inventory server"
  homepage "https://github.com/IamMrCupp/bench-parts"

  depends_on arch: :arm64
  depends_on macos: :ventura

  app "bench parts.app"

  # Not ~/Library/Application Support/bench-parts: that's the records and the
  # password, and removing an app should never delete those.
  zap trash: "~/Library/Preferences/com.iammrcupp.benchhud.bench-parts.plist"
end
