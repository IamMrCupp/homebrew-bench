cask "bench-suite" do
  version :latest
  sha256 :no_check

  # Nothing of its own to install: it pulls in the apps and bench-setup. The
  # url is only there because a cask has to have one.
  url "https://raw.githubusercontent.com/IamMrCupp/homebrew-bench/main/README.md"
  name "bench-suite"
  desc "Repair bench apps and the command that wires them together"
  homepage "https://github.com/IamMrCupp/bench-suite"

  depends_on cask: [
    "iammrcupp/bench/bench-parts",
    "iammrcupp/bench/benchhud",
    "iammrcupp/bench/benchhud-intake",
  ]
  depends_on formula: "iammrcupp/bench/bench-setup"

  stage_only true

  caveats <<~EOS
    Set the apps up and wire them to each other, without sudo:
      bench-setup
  EOS
end
