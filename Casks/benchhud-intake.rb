cask "benchhud-intake" do
  version "0.10.2"
  sha256 "5b6d38ac1416861a00eb2ae351ac72db8ba5fbcb2a7080511746ac516d856583"

  url "https://github.com/IamMrCupp/benchhud-intake/releases/download/v#{version}/benchhud-intake-#{version}.dmg"
  name "benchhud intake"
  desc "Menu-bar app that runs the repair intake server"
  homepage "https://github.com/IamMrCupp/benchhud-intake"

  depends_on arch: :arm64
  depends_on macos: :ventura

  app "benchhud intake.app"

  # Not ~/Library/Application Support/benchhud-intake: that's the records and the
  # password, and removing an app should never delete those.
  zap trash: "~/Library/Preferences/com.iammrcupp.benchhud.intake.plist"
end
