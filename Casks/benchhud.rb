cask "benchhud" do
  version "0.34.3"
  sha256 "7e7f1566918d0b641003a30d489f73cdd284dc3d03063d6a5bee03e7d2f2e1f8"

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
