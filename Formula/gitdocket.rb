class Gitdocket < Formula
  desc "Local-first project knowledge and work tracking for coding agents"
  homepage "https://gitdocket.com"
  license "Apache-2.0"

  uses_from_macos "git"

  on_macos do
    depends_on macos: :sequoia

    on_arm do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.5.0/gitdocket-0.5.0-darwin-arm64.tar.gz"
      sha256 "51641bb9828a6f39bdb748534d1f5eecd49172196916ee4bedde648aab3c63b2"
      depends_on arch: :arm64
    end
    on_intel do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.5.0/gitdocket-0.5.0-darwin-x64.tar.gz"
      sha256 "61c10b0ede137e1b28761c05a7ed5b917c685bccf41ca2b4a5fca9392732a12e"
      depends_on arch: :x86_64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.5.0/gitdocket-0.5.0-linux-arm64.tar.gz"
      sha256 "62646ea0fab647f45073b1e8d5ea096fbe8f6d84d3c91e27bc187a4e40e7f727"
      depends_on arch: :arm64
    end
    on_intel do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.5.0/gitdocket-0.5.0-linux-x64.tar.gz"
      sha256 "276ec6e9b053abdb76f1882f1e74670ab3cfa26d96248f6eff3fb710e0b36504"
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
