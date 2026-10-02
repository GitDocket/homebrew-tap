class Gitdocket < Formula
  desc "Local-first project knowledge and work tracking for coding agents"
  homepage "https://gitdocket.com"
  license "Apache-2.0"

  uses_from_macos "git"

  on_macos do
    depends_on macos: :sequoia

    on_arm do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.6.3/gitdocket-0.6.3-darwin-arm64.tar.gz"
      sha256 "e32546297230ca3e376fb875a7ffcfc300637559f3a7740ca734c63f0f7e091f"
      depends_on arch: :arm64
    end
    on_intel do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.6.3/gitdocket-0.6.3-darwin-x64.tar.gz"
      sha256 "19d4eb6837f44e3070f8f3049f804c0162fbc296c9c5dfc7c7a4c8d0f5acdf06"
      depends_on arch: :x86_64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.6.3/gitdocket-0.6.3-linux-arm64.tar.gz"
      sha256 "dfa74912a711e019c7fe279eb8d1318fb0188d9526c94c12d6e9d940d564d301"
      depends_on arch: :arm64
    end
    on_intel do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.6.3/gitdocket-0.6.3-linux-x64.tar.gz"
      sha256 "2872f378dac1f75ecb0c93cc3bc0a293f3d354a5eee3f5ebaebdbd8189bfc66e"
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
