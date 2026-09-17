class Gitdocket < Formula
  desc "Local-first project knowledge and work tracking for coding agents"
  homepage "https://gitdocket.com"
  license "Apache-2.0"

  uses_from_macos "git"

  on_macos do
    depends_on macos: :sequoia

    on_arm do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.4.1/gitdocket-0.4.1-darwin-arm64.tar.gz"
      sha256 "82981ba9803506f4cdaedfcea85b7097582f3cd8e5496667bec2f31e71773fdf"
      depends_on arch: :arm64
    end
    on_intel do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.4.1/gitdocket-0.4.1-darwin-x64.tar.gz"
      sha256 "285bda3c2cd80c8ba7d31b212d5c5eff378cc9250a09eb2d9c26e02c12d69731"
      depends_on arch: :x86_64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.4.1/gitdocket-0.4.1-linux-arm64.tar.gz"
      sha256 "bd2a4d102ba4533994c522ff742c81c173c44a5fb5179e0e45ea17dc2b1ab803"
      depends_on arch: :arm64
    end
    on_intel do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.4.1/gitdocket-0.4.1-linux-x64.tar.gz"
      sha256 "4377aecdb0e60ee4fe9cf3cbc8e251b2b03e51b1a33b78bd8fc451da325ea2e6"
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
