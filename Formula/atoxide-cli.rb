class AtoxideCli < Formula
  desc "Atopile compiler CLI"
  homepage "https://github.com/AngelOnFira/atoxide"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AngelOnFira/atoxide/releases/download/atoxide-cli-v0.1.3/atoxide-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0749bf06f67d4430e2603c7569259d3dc4c46b5877fce950c5562c9ac7073cb6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AngelOnFira/atoxide/releases/download/atoxide-cli-v0.1.3/atoxide-cli-x86_64-apple-darwin.tar.xz"
      sha256 "36660dbf915702615bf295a52fe8e2e73e92777dc5764242b434fdfdef00dfd4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/AngelOnFira/atoxide/releases/download/atoxide-cli-v0.1.3/atoxide-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f51c69c47e37387053acbc7616c5a3a1bcb3b300aee9af33f59810021665b6ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AngelOnFira/atoxide/releases/download/atoxide-cli-v0.1.3/atoxide-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7c5e9f7e7e6ef431beebf272ab8c29dc5523f6056fce9a1ffa75862ff093a5c4"
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
    bin.install "ato" if OS.mac? && Hardware::CPU.arm?
    bin.install "ato" if OS.mac? && Hardware::CPU.intel?
    bin.install "ato" if OS.linux? && Hardware::CPU.arm?
    bin.install "ato" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
