class Wavedash < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.com"
  homepage "https://wavedash.com"
  version "0.1.104"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.104/wavedash-aarch64-apple-darwin.tar.gz"
      sha256 "e2654661a4f978e24d3436a3976c4f14bc33311dc5fcb6590be0c6acc7cad9a9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.104/wavedash-x86_64-apple-darwin.tar.gz"
      sha256 "107bb7d41274bc7cfe7d9b680c1868e09f0cc0dd693479c6fe725ea01913c5f4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.104/wavedash-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "eee89b6047fc89263081468232ab3944716b931e7fbbc861a63a33c1011f568c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.104/wavedash-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6a7e704d9107d9e6d7bc11e939479bd99808652e378e6b0bdb3b05d135a6c513"
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
