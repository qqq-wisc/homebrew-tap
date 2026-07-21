class Tzap < Formula
  desc "A super fast, Rust-based optimizer for large Clifford+T circuits"
  homepage "https://github.com/qqq-wisc/tzap"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.3.1/tzap-opt-aarch64-apple-darwin.tar.xz"
      sha256 "f111811a02193c671c4a2f6de3b4e840ddce8cf1e5ead46280c40b7ca51d27d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.3.1/tzap-opt-x86_64-apple-darwin.tar.xz"
      sha256 "cb9461f6c6414e0b3ecba264aab44b47287b2a3509776bf20201de992d1cd6aa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.3.1/tzap-opt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3932c524c2fbc792efdd3a6a2ad9a657f74c0a7c50634840cd19b16dc378beaf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.3.1/tzap-opt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9b57857cd19c166ad216b106314e699eb157cbc0c1902ae3d5153a31b2529030"
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
