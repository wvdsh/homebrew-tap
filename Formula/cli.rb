class Cli < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.gg"
  homepage "https://wavedash.gg"
  version "0.1.25"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wavedash/cli/releases/download/0.1.25/cli-aarch64-apple-darwin.tar.xz"
      sha256 "8fe386ee246dbeacf04cd9abd0c9a01ea612f6d0069c6e3cafcae190d56ddc82"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wavedash/cli/releases/download/0.1.25/cli-x86_64-apple-darwin.tar.xz"
      sha256 "963c78bb0872543ed17541ebfac2ff860d85aa47bef7c36b6fd135ea30857d97"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wavedash/cli/releases/download/0.1.25/cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f0b571f6f4aa022b2370eab2e196e6138e3d06a194bf4f99eb3355e01aa8518b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wavedash/cli/releases/download/0.1.25/cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "77b9ede66048d8b5e6ced6d3a0cfcfedc16195441532d5eeff4541750b438c02"
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
