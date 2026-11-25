cask "benchhud" do
  version "0.34.1"
  sha256 "94e219226f8c00a104993b3a58559519e3250a7eb1f68f4f27239d5c8c214d1e"

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
