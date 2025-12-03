class Wvdsh < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.gg"
  homepage "https://wavedash.gg"
  version "0.1.38"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.38/wvdsh-aarch64-apple-darwin.tar.xz"
      sha256 "52aa5ee907b603e9ab1c3c4d877e7988ca2a6d13da7764a5d3a51b5135da2473"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.38/wvdsh-x86_64-apple-darwin.tar.xz"
      sha256 "b46ab28fee2da7ab556534825123f0ec74cd02fd0b00c4a9b4997ca8904ac43a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.38/wvdsh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fa82709ef025277fdb5310711f7af49b1f230a026de43f638ab67587171f17c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.38/wvdsh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "87ec6e6056264e2296b3a987c39cb5960fe1901b205063b0e0d82b98fd2398f5"
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
