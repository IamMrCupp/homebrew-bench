cask "benchhud" do
  version "0.34.0"
  sha256 "779252a895abe105fb9df7b03b963bee1c12c9ec7521cddaf22c3361286d0fa2"

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
