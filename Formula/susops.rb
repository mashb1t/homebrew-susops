class Susops < Formula
  desc "Lightweight CLI for website proxying and port forwarding"
  homepage "https://github.com/mashb1t/susops-cli"
  url "https://github.com/mashb1t/susops-cli/archive/refs/tags/v1.0.4.tar.gz"
  version "1.0.4"
  sha256 "f93a0123a39906262dbaa431982ed1899561b23b1d0c2be646eb7e07bc02f146"

  depends_on "autossh" => :recommended
  uses_from_macos "curl"

  def install
    bin.install "susops.sh" => "susops"
    bin.install_symlink "susops" => "so"
  end

  test do
    require "open3"

    # Use a clean workspace
    ENV["SUSOPS_WORKSPACE"] = testpath/"ws"

    # Ensure help output
    assert_match "Usage", shell_output("#{bin}/susops --help")
    assert_match "Usage", shell_output("#{bin}/so --help")

    # Workspace and PAC file creation
    shell_output("#{bin}/susops --help")
    assert_path_exists testpath/"ws/susops.pac"
    assert_match(/FindProxyForURL/, (testpath/"ws/susops.pac").read)

    # Starting without SSH host should fail
    output = shell_output("#{bin}/susops start", 1)
    assert_match "SSH host is empty, please set as argument", output

    # Add and remove a PAC host
    assert_match "Added example.com to PAC", shell_output("#{bin}/susops add example.com")
    pac = (testpath/"ws/susops.pac").read
    assert_match(/dnsDomainIs\(host, "\.example\.com"\)/, pac)
    assert_match "Removed example.com", shell_output("#{bin}/susops rm example.com")
    refute_match(/example\.com/, (testpath/"ws/susops.pac").read)

    # ls on empty configuration
    out = shell_output("#{bin}/susops ls")
    assert_match "PAC hosts:\n- None", out
    assert_match "Local forwards:\n- None", out
    assert_match "Remote forwards:\n- None", out

    # test when nothing is running
    out = shell_output("#{bin}/susops test --all", 1)
    assert_match(/not running, use "susops start" first/, out)

    # reset --force cleans up workspace
    (testpath/"ws/foo").write("bar")
    shell_output("#{bin}/susops reset --force")
    refute_path_exists testpath/"ws"

    # Invalid sub-command / usage
    assert_match "Usage: susops", shell_output("#{bin}/susops foobar", 1)
    assert_match "Usage: susops add -l", shell_output("#{bin}/susops add -l 8080", 1)
    assert_match "Usage: susops rm -r", shell_output("#{bin}/susops rm -r", 1)

    # add -l (local-forward) and duplicate-rule errors
    assert_match "Registered local forward", shell_output("#{bin}/susops add -l 8000 9000")
    dup = shell_output("#{bin}/susops add -l 8000 9000", 1)
    assert_match(/Local forward .*already registered/, dup)
    conflict = shell_output("#{bin}/susops add -l 8000 9001", 1)
    assert_match(/Local port 8000 is already the source of a local forward/, conflict)

    # add -r (remote-forward) and conflicting-port errors
    assert_match "Registered remote forward", shell_output("#{bin}/susops add -r 6500 7000")
    dup_r = shell_output("#{bin}/susops add -r 6500 7000", 1)
    assert_match(/already registered/, dup_r)
    shell_output("#{bin}/susops add -l 7001 6501")
    conflict_r = shell_output("#{bin}/susops add -r 6501 7001", 1)
    assert_match(/target of a local forward/, conflict_r)

    # rm -l / rm -r removing non-existent forwards
    err_l = shell_output("#{bin}/susops rm -l 1111", 1)
    assert_match "No local forward for localhost:1111", err_l
    err_r = shell_output("#{bin}/susops rm -r 2222", 1)
    assert_match(/No remote forward/, err_r)

    # start / stop idempotency and --keep-ports
    start_out = shell_output("#{bin}/susops start me@example.com 6000 6001")
    ssh = (testpath/"ws/ssh_host").read
    assert_match(/me@example.com/, ssh)
    assert_match(/PAC server:   🚀 started/, start_out)
    # stop with keep-ports retains ports and host
    stop_out = shell_output("#{bin}/susops stop --keep-ports")
    assert_match(/PAC server:   🛑 stopped/, stop_out)
    # restart without args should pick up stored ssh_host and ports
    restart_out = shell_output("#{bin}/susops start")
    ssh = (testpath/"ws/ssh_host").read
    assert_match(/me@example.com/, ssh)
    assert_match(/PAC server:   🚀 started/, restart_out)
    # verify port files stayed the same
    assert_equal "6000\n", (testpath/"ws/socks_port").read
    assert_equal "6001\n", (testpath/"ws/pac_port").read
    # stop without --keep-ports should remove ports and host
    stop_out = shell_output("#{bin}/susops stop")
    assert_match(/PAC server:   🛑 stopped/, stop_out)
    # verify port files are gone
    refute_path_exists testpath/"ws/socks_port"
    refute_path_exists testpath/"ws/pac_port"

    # restart preserves state
    shell_output("#{bin}/susops start me@example.com 6010 6011")
    out_restart = shell_output("#{bin}/susops restart")
    ssh = (testpath/"ws/ssh_host").read
    assert_match(/me@example.com/, ssh)
    assert_match(/🚀 started/, out_restart)
    assert_equal "6010\n", (testpath/"ws/socks_port").read
    assert_equal "6011\n", (testpath/"ws/pac_port").read
    shell_output("#{bin}/susops stop")

    # ps exit code and output
    out_ps, code = Open3.capture2e("#{bin}/susops ps")
    assert_equal 2, code.exitstatus
    assert_match(/SOCKS5 proxy:.*not running/, out_ps)
    assert_match(/PAC server:.*not running/, out_ps)

    # ls after adding forwards
    shell_output("#{bin}/susops add -l 8002 9002")
    shell_output("#{bin}/susops add -r 6502 7002")
    out_ls = shell_output("#{bin}/susops ls")
    assert_match "- localhost:8002 → me@example.com:9002", out_ls
    assert_match "- me@example.com:6502 → localhost:7002", out_ls

    # Check all, but in specific the ssh command
    out = shell_output("#{bin}/susops start host 6200 6201 -v")
    assert_match(/-N -T -D 6200 -L 8000:localhost:9000 -L 7001:localhost:6501 -L 8002:localhost:9002 -R 6500:localhost:7000 -R 6502:localhost:7002 host/, out)
    ssh = (testpath/"ws/ssh_host").read
    assert_match(/host/, ssh)
    assert_equal "6200\n", (testpath/"ws/socks_port").read
    assert_equal "6201\n", (testpath/"ws/pac_port").read
    shell_output("#{bin}/susops stop")

    # ensure everything is cleaned up
    _, code = Open3.capture2e("#{bin}/susops ps")
    assert_equal 2, code.exitstatus
  end
end
