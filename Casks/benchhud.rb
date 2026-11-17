cask "benchhud" do
  version "0.14.7"
  sha256 "50d4e331b74061f87ad7310750d849b923a7eb39ec3c45f8bd995063c4eda584"

  url "https://github.com/IamMrCupp/benchhud/releases/download/v#{version}/benchhud-#{version}.dmg"
  name "benchhud"
  desc "On-screen command center for an electronics repair bench"
  homepage "https://github.com/IamMrCupp/benchhud"

  depends_on arch: :arm64
  depends_on macos: :ventura

  app "benchhud.app"

  # Not ~/Library/Application Support/benchhud: that's the config and the job
  # records, and removing an app should never delete those.
  zap trash: [
    "~/Library/Preferences/com.iammrcupp.benchhud.plist",
    "~/Library/Saved Application State/com.iammrcupp.benchhud.savedState",
  ]
end
