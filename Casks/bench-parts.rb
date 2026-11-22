cask "bench-parts" do
  version "0.7.0"
  sha256 "8259b01425aa1065daab0d9345890cd8540a6d6f37eb398c2568aeda5971c79f"

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
