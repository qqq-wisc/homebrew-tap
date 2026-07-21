class TzapOpt < Formula
  desc "A super fast, Rust-based optimizer for large Clifford+T circuits"
  homepage "https://github.com/qqq-wisc/tzap"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.2.0/tzap-opt-aarch64-apple-darwin.tar.xz"
      sha256 "2b6d0f8b0e312dae751744e14794630d80935436e91686b9c4906b6cfd74f8a1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.2.0/tzap-opt-x86_64-apple-darwin.tar.xz"
      sha256 "7f1362ef002a7ae9cfc57805ed3b7b69aca9e43a5cefb06c3c9e286d18b32635"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.2.0/tzap-opt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e30d3b288fda7caea085908a89cc594c33c4581cbf98faf5edf2ba70a5d6825a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.2.0/tzap-opt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1690f47852a2687170e116beef407b370eff85d1b3708750072d95230dd3776d"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "tzap" if OS.mac? && Hardware::CPU.arm?
    bin.install "tzap" if OS.mac? && Hardware::CPU.intel?
    bin.install "tzap" if OS.linux? && Hardware::CPU.arm?
    bin.install "tzap" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
