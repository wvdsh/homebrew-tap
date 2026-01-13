class Wvdsh < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.com"
  homepage "https://wavedash.com"
  version "0.1.44"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.44/wvdsh-aarch64-apple-darwin.tar.xz"
      sha256 "1351a818332b76ec4cc8371b0fe5674f25a36e4e67d65af647f04e11f866bbbb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.44/wvdsh-x86_64-apple-darwin.tar.xz"
      sha256 "c84ffa090c897a16f8cf2c4a613998fff418174c84edbce191f23726d7773919"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.44/wvdsh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9c34b0e30ee0560377ac878b41c8945630956dcf7bdc8863d8c090298886abe1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.44/wvdsh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "040e48c07238c607049e4c86cc48d804719bba3f615c52be32e98667ba0876ea"
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
