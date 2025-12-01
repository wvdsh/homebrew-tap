class Wavedash < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.gg"
  homepage "https://wavedash.gg"
  version "0.1.24"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wavedash/cli/releases/download/0.1.24/wavedash-aarch64-apple-darwin.tar.xz"
      sha256 "51e67b1ce92eaf84dfae6595fd58ad8fdb4b17466860ee0010c0579292825f35"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wavedash/cli/releases/download/0.1.24/wavedash-x86_64-apple-darwin.tar.xz"
      sha256 "f1287c18e54c6cc00df6eef2618d696d521dd0e7359134c62d53ace8321a1621"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wavedash/cli/releases/download/0.1.24/wavedash-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "28bade5ddb932b659b18389c466803ec2d42805f9b57f07f4e3703238a70a401"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wavedash/cli/releases/download/0.1.24/wavedash-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a03acf274ba040ae96ef4002cee05c960658043c15ae5dc32d5786c870298b61"
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
