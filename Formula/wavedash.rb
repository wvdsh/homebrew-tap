class Wavedash < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.com"
  homepage "https://wavedash.com"
  version "0.1.75"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.75/wavedash-aarch64-apple-darwin.tar.gz"
      sha256 "3ab72b124c61140b4bcf13bd61ee57c6710b61610c50fc081e22e57a5084fb29"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.75/wavedash-x86_64-apple-darwin.tar.gz"
      sha256 "6b48b03bd60c371a26d2ea0d6d3f6734e40367790f87a03dc8da134950926e8d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.75/wavedash-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c4fa8a466189e4d9e28242f4dcf0c4d5aa6744d3e27f04d316e89eeb7a19e9d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.75/wavedash-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1e21ca6f831ecd6b90c48b44e8deb2af4fd221803cd0543744d44b1155286592"
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
