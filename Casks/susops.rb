cask "susops" do
  version "1.0.1"
  sha256 "23030b8c790e764b64999bac94b7ff57418d43443fe687d50542a9e5f3623b17"

  url "https://github.com/mashb1t/susops-mac/releases/download/v#{version}/SusOps.zip"
  name "SusOps"
  desc "Menu bar app for website proxying and port forwarding"
  homepage "https://github.com/mashb1t/susops-mac"

  app "SusOps.app"
end
