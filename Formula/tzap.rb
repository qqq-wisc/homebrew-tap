class Tzap < Formula
  desc "A super fast, Rust-based optimizer for large Clifford+T circuits"
  homepage "https://github.com/qqq-wisc/tzap"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.4.0/tzap-opt-aarch64-apple-darwin.tar.xz"
      sha256 "5d40162f97ae365134136843f32cbbd1a66bb78eeae3d44384b63695ea039d21"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.4.0/tzap-opt-x86_64-apple-darwin.tar.xz"
      sha256 "bc62b517a3e21e05e0b24779d2b077caf1d63997435b3285cf3014122a027bd2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.4.0/tzap-opt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cacc7521b170f9189e40130f87d212c717c32f524d8b0a67b016e395c7520c9b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.4.0/tzap-opt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b0e79fb5425c192c6e837eb409161b6d8c4cf32304c93029325abe5e418a661c"
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
