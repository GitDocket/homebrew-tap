class Gitdocket < Formula
  desc "Local-first project knowledge and work tracking for coding agents"
  homepage "https://gitdocket.com"
  license "Apache-2.0"

  uses_from_macos "git"

  on_macos do
    depends_on macos: :sequoia

    on_arm do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.6.0/gitdocket-0.6.0-darwin-arm64.tar.gz"
      sha256 "31f72bc73f33b13091006227df81bb146225e313798a077929c86961d2ac24bc"
      depends_on arch: :arm64
    end
    on_intel do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.6.0/gitdocket-0.6.0-darwin-x64.tar.gz"
      sha256 "508740237fc93d4b5e72de312f258d47a168aa23e7ce56c0848e864d42c7a833"
      depends_on arch: :x86_64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.6.0/gitdocket-0.6.0-linux-arm64.tar.gz"
      sha256 "fbd804f2d223f6e3b8f40ed0d04984461886ec500ea46ca0334f601d5a70e978"
      depends_on arch: :arm64
    end
    on_intel do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.6.0/gitdocket-0.6.0-linux-x64.tar.gz"
      sha256 "111c2532cc8fb9f06c8a481ea7106125169693a714e652ea2483f4909fb1346f"
      depends_on arch: :x86_64
    end
  end

  def install
    bin.install "docket", "docket-mcp"
    prefix.install "LICENSE", "THIRD_PARTY_NOTICES.txt"
    pkgshare.install "BUILD.json"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/docket --version").strip
    assert_equal version.to_s, shell_output("#{bin}/docket-mcp --version").strip
    system "git", "init", "-q"
    system bin/"docket", "init", "--project", "BREW", "--json"
    system bin/"docket", "task", "create", "--title", "Installed formula works", "--json"
    ready = JSON.parse(shell_output("#{bin}/docket ready --json"))
    assert_equal "Installed formula works", ready.fetch(0).fetch("title")
    system bin/"docket", "index"
    system bin/"docket", "index", "--check"
  end
end
