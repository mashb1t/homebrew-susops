cask "susops" do
  version "1.0.1"
  sha256 "aba38b226bd7c16a15e6efd82e7a05181a90ff3098c9a05e35fc8e155e416263"

  url "https://github.com/mashb1t/susops-mac/releases/download/v#{version}/SusOps.zip"
  name "SusOps"
  desc "Menu bar app for website proxying and port forwarding"
  homepage "https://github.com/mashb1t/susops-mac"

  app "SusOps.app"
end
