class Susops < Formula
  desc "Lightweight CLI for website proxying and port forwarding"
  homepage "https://github.com/mashb1t/susops-cli"
  version "1.0.1"
  url "https://github.com/mashb1t/susops-cli/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "9c2324072fa2f7f67622cd006cba97c4cbac677c33ee0d0615458894b5a4639b"

  def install
    bin.install "susops.sh" => "susops"
    bin.install_symlink "susops" => "so"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/susops --help")
    assert_match "Usage", shell_output("#{bin}/so --help")
  end
end
