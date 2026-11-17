cask "bench-parts" do
  version "0.6.0"
  sha256 "908b87b4a84c84292312753621390827ad70c22893becc7440fae0c0b6d7f1dc"

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
