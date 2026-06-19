class Wavedash < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.com"
  homepage "https://wavedash.com"
  version "0.1.85"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.85/wavedash-aarch64-apple-darwin.tar.gz"
      sha256 "b6e0d3a57396a21bff8c7eb6edb5306557d27b7a9ad830def5d4ea9f06131e33"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.85/wavedash-x86_64-apple-darwin.tar.gz"
      sha256 "c6bb185422819e6db82f38cecfe03a5a84439117e1783849cd3513480bb02919"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.85/wavedash-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8f26242073e9f37fc19e70b4543e800394d4b673d0524dfb74bf7b4d0e79bb00"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.85/wavedash-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ead1556a6b5f0b3cd2536f11af138ac04dc7775f257ebcda87b75e3d8c74a246"
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
    bin.install "wavedash" if OS.mac? && Hardware::CPU.arm?
    bin.install "wavedash" if OS.mac? && Hardware::CPU.intel?
    bin.install "wavedash" if OS.linux? && Hardware::CPU.arm?
    bin.install "wavedash" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
