class Susops < Formula
  desc "Lightweight CLI for website proxying and port forwarding"
  homepage "https://github.com/mashb1t/susops-cli"
  url "https://github.com/mashb1t/susops-cli/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "399420ff3221f65553147739fec588f49831992bb2b455cd4ecaf0bc8d8873e3"
  license "MIT"

  def install
    bin.install "susops.sh" => "susops"
    bin.install_symlink "susops" => "so"
  end

  test do
    assert_match "susops", shell_output("#{bin}/susops --help", 1)
    assert_match "susops", shell_output("#{bin}/so --help", 1)
  end
end