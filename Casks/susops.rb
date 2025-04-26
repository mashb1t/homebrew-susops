cask "susops" do
  name "SusOps"
  desc "MacOS menu bar app for website proxying and port forwarding"
  homepage "https://github.com/mashb1t/susops-mac"
  license "MIT"
  version "1.0.0"
  sha256 "ddd9c2140c1a0bce02a598df27e0bf9b1f7c83db742bc6f89b35226c03bb3160"
  url "https://github.com/mashb1t/susops-mac/releases/download/v#{version}/SusOps.zip"

  app "SusOps.app"
end