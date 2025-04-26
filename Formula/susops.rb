class Susops < Formula
  desc "Lightweight CLI for website proxying and port forwarding"
  homepage "https://github.com/mashb1t/susops-cli"
  version "1.0.1"
  url "https://github.com/mashb1t/susops-cli/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "70131258fbd65c30b67b2a73493163347734b58fbdeaf7631e20469a5a8007ed"

  def install
    bin.install "susops.sh" => "susops"
    bin.install_symlink "susops" => "so"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/susops --help")
    assert_match "Usage", shell_output("#{bin}/so --help")
  end
end
