cask "bench-parts" do
  version "0.5.1"
  sha256 "9ddb00292649da46bc9caf8b1c74805c356445555254681c1f820c7978e187b1"

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
