cask "susops" do
  version "1.0.1"
  sha256 "6f6d8df45746dfb2233943dd544316f0334d5a33a92225aafc792159ec8c63b7"

  url "https://github.com/mashb1t/susops-mac/releases/download/v#{version}/SusOps.zip"
  name "SusOps"
  desc "Menu bar app for website proxying and port forwarding"
  homepage "https://github.com/mashb1t/susops-mac"

  app "SusOps.app"
end
