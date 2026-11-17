cask "benchhud" do
  version "0.14.4"
  sha256 "1b15183c25ce5b75e728252ef3ba6a585baca41e24abd6520c0b16f586f25028"

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
