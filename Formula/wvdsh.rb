class Wvdsh < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.com"
  homepage "https://wavedash.com"
  version "0.1.47"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.47/wvdsh-aarch64-apple-darwin.tar.xz"
      sha256 "4e047652d805045e215b3b9a8977b11c26c9c9ad87fb366b913d2ad041837df5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.47/wvdsh-x86_64-apple-darwin.tar.xz"
      sha256 "563a4944098b2ec9dab864985c6040ef141b372bee2325c0d85ba26b39f63844"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.47/wvdsh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "18456d5cb842886c7c6969b5ca598cf095e4a382c3a3ad0b8f92d9ae6e3ff1e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.47/wvdsh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "48c4f1451bc28c527c86f7e258ee6591da8f027a02febccf40970f7c855da493"
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
