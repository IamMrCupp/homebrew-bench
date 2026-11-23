cask "benchhud-intake" do
  version "0.10.0"
  sha256 "90d745e23cdf82aec8340b31a7612fb95e1fbda3c4e9178cb711f5c62d55f684"

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
