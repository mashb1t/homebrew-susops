class Susops < Formula
  desc "Lightweight CLI for website proxying and port forwarding"
  homepage "https://github.com/mashb1t/susops-cli"
  version "1.0.1"
  url "https://github.com/mashb1t/susops-cli/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "05e0af867972e3a9bb6a177cced6fde3e22f664191b43e96180718eea5671896"

  def install
    bin.install "susops.sh" => "susops"
    bin.install_symlink "susops" => "so"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/susops --help")
    assert_match "Usage", shell_output("#{bin}/so --help")
  end
end
