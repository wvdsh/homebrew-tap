class Wavedash < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.com"
  homepage "https://wavedash.com"
  version "0.1.58"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.58/wavedash-aarch64-apple-darwin.tar.xz"
      sha256 "e3b92a7f2301444acb29437bb13b3ec6eefd03a53200ec41ee5f50494377f03a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.58/wavedash-x86_64-apple-darwin.tar.xz"
      sha256 "a6582d18ca32e4f59a2415a8f6f71c208237d64a795309e5661d632ffb063423"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.58/wavedash-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a0da432c9007a6f916ddb5b0537c0e342e429c915910b8488da81928b78e73dc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.58/wavedash-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f0b851c2dfff2d56464c28fd83572709340e3d65f1106dd4cffa4a95bb1a2c17"
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
