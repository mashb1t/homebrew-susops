class Susops < Formula
  desc "Lightweight CLI for website proxying and port forwarding"
  homepage "https://github.com/mashb1t/susops-cli"
  url "https://github.com/mashb1t/susops-cli/archive/refs/tags/v2.0.5.tar.gz"
  version "2.0.5"
  sha256 "54ce20a50eb7b259aa969062408ddc43e2f01a0beba0f8023e82b2cd47bfa310"

  depends_on "autossh" => :recommended
  depends_on "yq"
  uses_from_macos "curl"

  def install
    bin.install "susops.sh" => "susops"
    bin.install_symlink "susops" => "so"
  end

  test do
    require "open3"

    # Use a clean workspace
    ENV["SUSOPS_WORKSPACE"] = testpath/"ws"

    # ensure susops isn't running
    shell_output("pkill -f susops-pac || true")
    shell_output("pkill -f susops-ssh || true")

    # REPLACE THIS WITH YOUR SSH HOST
    host = "pi3"

    # Ensure help output
    assert_match "No connection specified and no default connection found.", shell_output("#{bin}/susops --help", 1)
    assert_match "No connection specified and no default connection found.", shell_output("#{bin}/so --help", 1)

    # Workspace and PAC file creation
    shell_output("#{bin}/susops --help", 1)
    assert_path_exists testpath/"ws/config.yaml"
    assert_match(/pac_server_port: 0/, (testpath/"ws/config.yaml").read)
    refute_path_exists testpath/"ws/susops.pac"

    # add connection
    output = shell_output("#{bin}/susops add-connection", 1)
    assert_match "Usage: susops add-connection TAG", output
    output = shell_output("#{bin}/susops add-connection tag", 1)
    assert_match "Error: SSH host is required", output
    output = shell_output("#{bin}/susops add-connection tag invalid-hostname-123", 1)
    assert_match "Error: SSH connection to host 'invalid-hostname-123' failed", output
    output = shell_output("#{bin}/susops add-connection tag #{host}", 0)
    assert_match "Connection [tag]:", output
    assert_match "tested & added", output

    # Add and remove a PAC host
    output = shell_output("#{bin}/susops add example.com")
    assert_match "Connection [tag]:", output
    assert_match "Added example.com", output
    assert_match(/example\.com/, (testpath/"ws/config.yaml").read)

    output = shell_output("#{bin}/susops rm example.com")
    assert_match "Removed example.com", output
    refute_match(/example\.com/, (testpath/"ws/config.yaml").read)

    # ls complete config
    output = shell_output("#{bin}/susops ls")
    assert_equal(output, (testpath/"ws/config.yaml").read)

    # test when nothing is running
    out = shell_output("#{bin}/susops test example.com")
    assert_match(/not running/, out)

    # Starting without SSH host should fail
    output = shell_output("#{bin}/susops start")
    assert_match(/SOCKS5 proxy \[tag\]:\s+🚀 started/, output)
    assert_match(/PAC server:\s+🚀 started/, output)

    # test when is running
    out = shell_output("#{bin}/susops test example.com")
    assert_match(/✅ example.com via SOCKS/, out)

    # restart
    out = shell_output("#{bin}/susops restart")
    assert_match(/SOCKS5 proxy \[tag\]:\s+🚀 started/, out)
    assert_match(/PAC server:\s+🚀 started/, out)

    # stop
    out = shell_output("#{bin}/susops stop")
    assert_match(/SOCKS5 proxy \[tag\]:\s+🛑 stopped/, out)
    assert_match(/PAC server:\s+🛑 stopped/, out)

    # Invalid sub-command / usage
    assert_match "Usage: susops", shell_output("#{bin}/susops foobar", 1)
    assert_match "Usage: susops add -l", shell_output("#{bin}/susops add -l 8080", 1)
    assert_match "Usage: susops rm -r", shell_output("#{bin}/susops rm -r", 1)

    # add -l (local-forward) and duplicate-rule errors
    assert_match "✅ Added local forward [8000] localhost:8000 → pi3:9000", shell_output("#{bin}/susops add -l 8000 9000")
    dup = shell_output("#{bin}/susops add -l 8000 9000", 1)
    assert_match(/Local forward .*already registered/, dup)
    conflict = shell_output("#{bin}/susops add -l 8000 9001", 1)
    assert_match(/Local port 8000 is already the source of a local forward/, conflict)

    # add -r (remote-forward) and conflicting-port errors
    assert_match "✅ Added remote forward [6500] pi3:6500 → localhost:7000", shell_output("#{bin}/susops add -r 6500 7000")
    dup_r = shell_output("#{bin}/susops add -r 6500 7000", 1)
    assert_match(/already registered/, dup_r)
    shell_output("#{bin}/susops add -l 7001 6501")
    conflict_r = shell_output("#{bin}/susops add -r 6501 7001", 1)
    assert_match(/Local port 7001 is already the source of a local forward/, conflict_r)

    # rm -l / rm -r removing non-existent forwards
    err_l = shell_output("#{bin}/susops rm -l 1111", 1)
    assert_match "No local forward for localhost:1111", err_l
    err_r = shell_output("#{bin}/susops rm -r 2222", 1)
    assert_match(/No remote forward/, err_r)

    # ps exit code and output
    out_ps, code = Open3.capture2e("#{bin}/susops ps")
    assert_equal 3, code.exitstatus
    assert_match(/SOCKS5 proxy \[tag\]:.*not running/, out_ps)
    assert_match(/PAC server:.*not running/, out_ps)

    # Check all, but in specific the ssh command
    out = shell_output("#{bin}/susops start #{host} 6200 6201 -v")
    assert_match(/-N -T -D 6200 -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -L 8000:localhost:9000 -L 7001:localhost:6501 -R 6500:localhost:7000 #{host}/, out)
    shell_output("#{bin}/susops stop")

    # ensure everything is cleaned up
    _, code = Open3.capture2e("#{bin}/susops ps")
    assert_equal 3, code.exitstatus

    # reset
    shell_output("#{bin}/susops reset --force", 0)

    # —————————————————————————————————————————————————————————————
    #  Add 2 connections, one PAC host each, then test --all
    # —————————————————————————————————————————————————————————————

    # Add two connections
    shell_output("#{bin}/susops add-connection c1 #{host}", 0)
    shell_output("#{bin}/susops add-connection c2 #{host}", 0)

    # Add one PAC host for each connection
    shell_output("#{bin}/susops --connection c1 add example1.com", 0)
    shell_output("#{bin}/susops --connection c2 add example2.org", 0)

    # Start the proxy (will pick up both connections and PAC hosts)
    shell_output("#{bin}/susops start", 0)

    # Run test --all and assert both domains are reported as reachable
    all_out = shell_output("#{bin}/susops test --all", 0)
    assert_match(/Testing connection 'c1'.*?✅ example1\.com via SOCKS/m, all_out)
    assert_match(/Testing connection 'c2'.*?✅ example2\.org via SOCKS/m, all_out)

    # Cleanup
    shell_output("#{bin}/susops reset --force", 0)

    # Be double sure everything is cleaned up
    shell_output("pkill -f susops-pac || true")
    shell_output("pkill -f susops-ssh || true")
  end
end
