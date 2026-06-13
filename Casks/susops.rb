cask "susops" do
  # version + sha256 rewritten by scripts/update_homebrew_sha.py on each tag.
  version "3.0.0-rc6.dev2"
  sha256 "170529ee1c1006e3e165b9f0e869b7daab63fed74b8da8af0a085985dbccf3f0"

  url "https://github.com/mashb1t/susops/releases/download/v#{version}/SusOps-#{version}-arm64.dmg"
  name "SusOps"
  desc "SSH SOCKS5 proxy manager — macOS tray app"
  homepage "https://github.com/mashb1t/susops"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"
  depends_on arch: :arm64

  app "SusOps.app"

  zap trash: [
    "~/.susops",
    "~/Library/Application Support/SusOps",
    "~/Library/Logs/SusOps",
  ]
end
