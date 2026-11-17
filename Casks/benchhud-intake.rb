cask "benchhud-intake" do
  version "0.4.0"
  sha256 "83360f0c3e27fbbf2228d10d5b8f6c116e58a4c1add597403836aa1927e33750"

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
