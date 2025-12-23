class Wvdsh < Formula
  desc "Cross-platform CLI tool for uploading game projects to wavedash.gg"
  homepage "https://wavedash.gg"
  version "0.1.40"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.40/wvdsh-aarch64-apple-darwin.tar.xz"
      sha256 "c5f4e4d70b7d1fed5dc3c4643bdadeb801dcceadf7e741cc2a349956dad99707"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.40/wvdsh-x86_64-apple-darwin.tar.xz"
      sha256 "02af1f347574da08687b775628b5b094a894e28a3f2d7da060bdeec80f5c0c97"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wvdsh/cli/releases/download/0.1.40/wvdsh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "049e00656c80f1eed62eb983a03de0ec1b01627b31043fadb285aa4e5ee19110"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wvdsh/cli/releases/download/0.1.40/wvdsh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b65eb67f452afac7a57cb367cf1edccfe4ab55eedcde614d86b4404680bfc29f"
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
