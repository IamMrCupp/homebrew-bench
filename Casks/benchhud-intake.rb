cask "benchhud-intake" do
  version "0.5.0"
  sha256 "86f7d7c72465c39d03296a63be608f7f73b39bb0d79a7e2e58c0e14aeef3184a"

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
