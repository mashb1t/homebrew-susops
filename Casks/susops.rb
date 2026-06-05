cask "susops" do
  # version + sha256 rewritten by scripts/update_homebrew_sha.py on each tag.
  version "3.0.0-rc3.dev8"
  sha256 "228347244aa70e5bb914474c26ac553296b9c35f21e337b30c6339931e3c24a9"

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
