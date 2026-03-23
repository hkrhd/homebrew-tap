class Jufu < Formula
  desc "Jujutsu log viewer TUI inspired by keifu"
  homepage "https://github.com/hkrhd/jufu"
  version "0.1.3"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/hkrhd/jufu/releases/download/v0.1.3/jufu-aarch64-apple-darwin.tar.xz"
      sha256 "ef48f25870102d9dbfea6d7c44a87bc039edc018408d4215f919816f72b6569b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hkrhd/jufu/releases/download/v0.1.3/jufu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "08a6dd91f68de2273bfb2ef338ba54b213ee1d77a9640b709610ccc80df92df0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hkrhd/jufu/releases/download/v0.1.3/jufu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "67ac3f7160b5578083c0cccb6fce48c234e88ea9028584f6eb792724c56a368c"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    bin.install "jufu" if OS.mac? && Hardware::CPU.arm?
    bin.install "jufu" if OS.linux? && Hardware::CPU.arm?
    bin.install "jufu" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
