cask "benchhud-intake" do
  version "0.4.1"
  sha256 "cbb525ecf3018560b49a529916e5b9d687f0187ee806c7611a2cff7c4bd080b1"

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
