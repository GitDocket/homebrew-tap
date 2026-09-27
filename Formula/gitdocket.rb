class Gitdocket < Formula
  desc "Local-first project knowledge and work tracking for coding agents"
  homepage "https://gitdocket.com"
  license "Apache-2.0"

  uses_from_macos "git"

  on_macos do
    depends_on macos: :sequoia

    on_arm do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.6.1/gitdocket-0.6.1-darwin-arm64.tar.gz"
      sha256 "1c50d27339d2b5428d18d1765dcdda7321b0911b790ce093296f918cf5e35b3c"
      depends_on arch: :arm64
    end
    on_intel do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.6.1/gitdocket-0.6.1-darwin-x64.tar.gz"
      sha256 "2b263151229c780ede2bfc9989bb9be4287943a723e9315fab730b4c15bcd5bb"
      depends_on arch: :x86_64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.6.1/gitdocket-0.6.1-linux-arm64.tar.gz"
      sha256 "7ed75d0b2246b38feee8dc5e610c15ea13f4d0231542ad7e73f8524092fb322b"
      depends_on arch: :arm64
    end
    on_intel do
      url "https://github.com/GitDocket/gitdocket/releases/download/v0.6.1/gitdocket-0.6.1-linux-x64.tar.gz"
      sha256 "3bfad61911315d33f825d39747c159d251eb050d85d40ce5b29e2c8e392bdd3d"
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
