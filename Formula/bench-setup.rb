class BenchSetup < Formula
  desc "Sets up the repair bench apps and wires them to each other"
  homepage "https://github.com/IamMrCupp/bench-suite"
  url "https://github.com/IamMrCupp/bench-suite/archive/refs/tags/v1.5.7.tar.gz"
  sha256 "e5d7e33cf6b8ad51da2750b0c2b9a462cd14ce3786dd3554b243f652316b2dd1"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

  def install
    # Plain Python with no dependencies: the package goes in libexec as it is,
    # with the compose file beside it, where `bench-setup services --compose`
    # looks for one.
    libexec.install "src/bench_setup", "compose.yaml"
    python = formula_opt_bin("python@3.13")/"python3.13"
    (bin/"bench-setup").write <<~SH
      #!/bin/sh
      exec "#{python}" -IB -c 'import sys; sys.path.insert(0, "#{libexec}"); from bench_setup.cli import main; sys.exit(main())' "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bench-setup --version")
    # Reads only: on a Mac with none of the bench apps it says so and exits 0.
    assert_match "bench-recon", shell_output("#{bin}/bench-setup doctor")
  end
end
