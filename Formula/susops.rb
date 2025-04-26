class Susops < Formula
  desc "Lightweight CLI for website proxying and port forwarding"
  homepage "https://github.com/mashb1t/susops-cli"
  version "1.0.0"
  sha256 "399420ff3221f65553147739fec588f49831992bb2b455cd4ecaf0bc8d8873e3"
  url "https://github.com/mashb1t/susops-cli/archive/refs/tags/v#{version}.tar.gz"

  def install
    bin.install "susops.sh" => "susops"
    bin.install_symlink "susops" => "so"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/susops --help")
    assert_match "Usage", shell_output("#{bin}/so --help")
  end
end
