class Wavedash < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.com"
  homepage "https://wavedash.com"
  version "0.1.102"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.102/wavedash-aarch64-apple-darwin.tar.gz"
      sha256 "bf33bd16839d1e06559d3790be9464dd071c08fcf9b7588ea7e94a5b6c131c8b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.102/wavedash-x86_64-apple-darwin.tar.gz"
      sha256 "e6d128c608725214ca52d90b79704043f2dd22687885c854ab3c09f7f1078649"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.102/wavedash-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "49835223d0c991f1703356746d4a8f77c3d941320af0b2a6bc8603987f4afece"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.102/wavedash-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f2e8ff17367be2049d52f69facfbb2180a8d24a7533c342cc5acbd99fa7f1081"
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
