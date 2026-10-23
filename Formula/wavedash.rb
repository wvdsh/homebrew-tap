class Wavedash < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.com"
  homepage "https://wavedash.com"
  version "0.1.103"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.103/wavedash-aarch64-apple-darwin.tar.gz"
      sha256 "c9c3fea6b32c52cd5c59c7074f12596697ad9abf606445a0df78fddd9ec7457b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.103/wavedash-x86_64-apple-darwin.tar.gz"
      sha256 "969066e13214ac4d2424a511c99526b6ebf3b0d9bc71b93865633f1258b01b0a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.103/wavedash-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c0a96cc803f62fdd4fd1bbe37de724e020212b4b342be7d92080be08f5d11d9c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.103/wavedash-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "91b2961385124f1136a2cae006cbe93710326d652b1e434eec8bc7dda4ab5c27"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "wavedash"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "wavedash"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "wavedash"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "wavedash"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
