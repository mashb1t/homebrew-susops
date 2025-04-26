class Susops < Formula
  desc "Lightweight CLI for website proxying and port forwarding"
  homepage "https://github.com/mashb1t/susops-cli"
  url "https://github.com/mashb1t/susops-cli/archive/refs/tags/v1.0.1.tar.gz"
  version "1.0.1"
  sha256 "eefa9c9542c4cae62e7854d4847f761ae7f8447c1ef5dc9632ee7ffaf9364c24"

  def install
    bin.install "susops.sh" => "susops"
    bin.install_symlink "susops" => "so"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/susops --help")
    assert_match "Usage", shell_output("#{bin}/so --help")
  end
end
