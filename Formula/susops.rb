class Susops < Formula
  desc "Lightweight CLI for website proxying and port forwarding"
  homepage "https://github.com/mashb1t/susops-cli"
  version "1.0.2"
  url "https://github.com/mashb1t/susops-cli/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "2cc68162d5f063c5e8a9b4be78ca0bec573ee43da187458ca82d9faf678e5127"

  def install
    bin.install "susops.sh" => "susops"
    bin.install_symlink "susops" => "so"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/susops --help")
    assert_match "Usage", shell_output("#{bin}/so --help")
  end
end
