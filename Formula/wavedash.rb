class Wavedash < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.com"
  homepage "https://wavedash.com"
  version "0.1.105"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.105/wavedash-aarch64-apple-darwin.tar.gz"
      sha256 "a78286119ae0a4730fae0ff0822cae79a4c1efea60d6ce00960eb3f615cd6fec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.105/wavedash-x86_64-apple-darwin.tar.gz"
      sha256 "28acdf018b2f3797ed085046ed5d2f34c9302c4abc7aa8bd0a78f69c86d6c490"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.105/wavedash-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "99172b778a2c918776d4527b9518234f581ff152927c14291b253e8af7f2de0e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.105/wavedash-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dfdcc89e61328690f89372609c4f93aaf67e3db929ae2dcf698cd8029c72655a"
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
