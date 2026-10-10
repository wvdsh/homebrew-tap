class Wavedash < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.com"
  homepage "https://wavedash.com"
  version "0.1.99"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.99/wavedash-aarch64-apple-darwin.tar.gz"
      sha256 "f2446f761e344b22634eca7ba36308372dc7cecfae60104b8c186a9058b68e13"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.99/wavedash-x86_64-apple-darwin.tar.gz"
      sha256 "84ec186333aec80139b6f647e3a64c91d319c0c7906de84699cea675910db64d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.99/wavedash-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9add8dbc7f8f40f173b6d2a5cecb45cabdd92cac405bcf54556c070a665a93d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.99/wavedash-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cedbee81d87206612346edad3dbed63ff4baf5cdeee192600808965c3a6dd1cc"
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
