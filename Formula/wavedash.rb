class Wavedash < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.com"
  homepage "https://wavedash.com"
  version "0.1.79"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.79/wavedash-aarch64-apple-darwin.tar.gz"
      sha256 "20e47910024bae4113c4ccc526878c2a8e37970a937236cb75aad90f26df2584"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.79/wavedash-x86_64-apple-darwin.tar.gz"
      sha256 "814b2fa174fa42c2c03563d765ec65b8052a1d3585bc8bbd52e7bc4be25a04c3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.79/wavedash-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "488d30ddd30cad42b77aa600374f5488c08eedee56b905fcb9f8c852d9866274"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.79/wavedash-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ad30442e1da1144d36e7ea1eab51912bd44d9be636c2207d0263898982c431c7"
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
