class Jufu < Formula
  desc "Jujutsu log viewer TUI inspired by keifu"
  homepage "https://github.com/hkrhd/jufu"
  version "0.1.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/hkrhd/jufu/releases/download/v0.1.5/jufu-aarch64-apple-darwin.tar.xz"
    sha256 "375af0c9bfe7edff2458d668f9b04e4e74e3469de70892fd05c730b86f648253"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hkrhd/jufu/releases/download/v0.1.5/jufu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "935ea31aba4b86571da0eedafb50502d05c66cf350c07cde324be224de7f76cf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hkrhd/jufu/releases/download/v0.1.5/jufu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7e9c6d47647d2736170db04389d910b0e5d9b5d957a1dbbf01226ef6daca0c3e"
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
