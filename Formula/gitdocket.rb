class Gitdocket < Formula
  desc "Local-first project knowledge and work tracking for coding agents"
  homepage "https://gitdocket.com"
  license "Apache-2.0"

  uses_from_macos "git"

  on_macos do
    depends_on macos: :sequoia

    on_arm do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.6.4/gitdocket-0.6.4-darwin-arm64.tar.gz"
      sha256 "c0a51a3e5fd54e4a5cbd6aabd578ea9fe6c433616dc64a9a39dc883c36f55df7"
      depends_on arch: :arm64
    end
    on_intel do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.6.4/gitdocket-0.6.4-darwin-x64.tar.gz"
      sha256 "e1939f456e099962ed66cd2eec67a1d1d0f711bd3c16276200626645d71894d7"
      depends_on arch: :x86_64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.6.4/gitdocket-0.6.4-linux-arm64.tar.gz"
      sha256 "7cf395d7b635abc595d1abe0ffadb027c8a3e76799becbcb85d2336d597fb607"
      depends_on arch: :arm64
    end
    on_intel do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.6.4/gitdocket-0.6.4-linux-x64.tar.gz"
      sha256 "f64a03ba38b5a31c766324d7bcf514da32428ff62dcca5c2907c618447aa7654"
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
