cask "susops" do
  # version + sha256 rewritten by scripts/update_homebrew_sha.py on each tag.
  version "3.0.0"
  sha256 "d65a145db8254fd0393525ffc3a149515d2bbc1378d9c720720b4c3ef9d0de69"

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
  # socat is required for UDP port forwarding (core/socat.py shells out to it);
  # the bundled .app can't ship a system binary, so pull it as a hard dep.
  depends_on formula: "socat"

  app "SusOps.app"

  zap trash: [
    "~/.susops",
    "~/Library/Application Support/SusOps",
    "~/Library/Logs/SusOps",
  ]
end
