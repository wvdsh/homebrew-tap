class Wvdsh < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.gg"
  homepage "https://wavedash.gg"
  version "0.1.42"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.42/wvdsh-aarch64-apple-darwin.tar.xz"
      sha256 "456dd6348b07a124b75ee1014a39524ea743e0e92c8ed535e2122b179c4963a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.42/wvdsh-x86_64-apple-darwin.tar.xz"
      sha256 "16c32a9c9c0a9ee050605975d89e2c1d01533be95dc5e938da37ed03e836e0d0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.42/wvdsh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "013234c7bf5a5de2fe9c6a50509219672723fe85b388f9226a2c070f68c80007"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.42/wvdsh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c092ca2771b9e65169153cff2a95cbeac66f30676eca4845b3f727a0cf80eb0"
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
