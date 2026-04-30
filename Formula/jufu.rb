class Jufu < Formula
  desc "Jujutsu log viewer TUI inspired by keifu"
  homepage "https://github.com/hkrhd/jufu"
  version "0.1.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/hkrhd/jufu/releases/download/v0.1.4/jufu-aarch64-apple-darwin.tar.xz"
    sha256 "a402390c45d77dc1280b8ff98029a5bd03c6db3fc52a53281ea3af840cca03f9"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hkrhd/jufu/releases/download/v0.1.4/jufu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "60ce3a87f35816b62ef3efb275455fbe9628bad1452142cbaf7373740d1cd427"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hkrhd/jufu/releases/download/v0.1.4/jufu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "56452d90d7834b86886d46a0009f36d9137d47785931707556179a5e961baa91"
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
