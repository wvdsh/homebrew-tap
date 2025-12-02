class Wvdsh < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.gg"
  homepage "https://wavedash.gg"
  version "0.1.33"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.33/wvdsh-aarch64-apple-darwin.tar.xz"
      sha256 "00a2c6c5cb0483c3e472fca5cd176553b4ef2dc7b529a5693ccb6de38ddb0452"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.33/wvdsh-x86_64-apple-darwin.tar.xz"
      sha256 "b90b4a10f7e9a4b5cb0b9b23e3c3160932715a2f072c8a2a07dfb23e363da13e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.33/wvdsh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3f4ca6405f3828d1c89b1cfdd9cadcced71bd93582e9b85c6c146b9c9c1bbd27"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.33/wvdsh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "249b949f0aa90e97fe435d6180e4180b70b220ae02864e7c5a09d79299bd248a"
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
