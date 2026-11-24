cask "bench-parts" do
  version "0.7.1"
  sha256 "a4409a1be4994cba4b758756aaf59352b885c9ed2c964bbb715b9cfcb4d3ca9b"

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
