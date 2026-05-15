class Wavedash < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.com"
  homepage "https://wavedash.com"
  version "0.1.81"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.81/wavedash-aarch64-apple-darwin.tar.gz"
      sha256 "64a1604b28da446fe8ffa11305f3eb30c8cbaf714b95a43806b5dba862c1d877"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.81/wavedash-x86_64-apple-darwin.tar.gz"
      sha256 "d3a9a9d034366decab81237b51cf3d4e4d47f41992eee408f2771748059e6489"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.81/wavedash-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c385e98b6c33a5cf684ef9bef04b35f9865ad4260c19d1ca2feac263aab65d28"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.81/wavedash-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e08c97bd2972658f9805d1fa4d423ea254b91f8dc0913d6ac6493d476b7f35b4"
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
