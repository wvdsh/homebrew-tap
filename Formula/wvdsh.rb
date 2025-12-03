class Wvdsh < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.gg"
  homepage "https://wavedash.gg"
  version "0.1.35"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.35/wvdsh-aarch64-apple-darwin.tar.xz"
      sha256 "098cc808945e7bb3048a72f14c947886a054d58ec14926f38f2035a3c15edca0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.35/wvdsh-x86_64-apple-darwin.tar.xz"
      sha256 "5274fcd0d767d7e491a5ef308a2e61f9347d6ce892b85f73b17eba97a6c3f1e1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.35/wvdsh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e83607f2db52be607c4b06f01256bca01783571f69abcdb284113c3ab48123dc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.35/wvdsh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f02ca4c2446a904ae10df95b23a810408ab2ff0a041f04a91d7e6da349f89eb4"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "wvdsh" if OS.mac? && Hardware::CPU.arm?
    bin.install "wvdsh" if OS.mac? && Hardware::CPU.intel?
    bin.install "wvdsh" if OS.linux? && Hardware::CPU.arm?
    bin.install "wvdsh" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
