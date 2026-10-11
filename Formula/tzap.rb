class Tzap < Formula
  desc "A super fast, Rust-based optimizer for large Clifford+T circuits"
  homepage "https://github.com/qqq-wisc/tzap"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.8.0/tzap-opt-aarch64-apple-darwin.tar.xz"
      sha256 "db17cb3f4d2fc755910df237ddcfc9131b3c5262b7e80760c6d6a058b2ee00c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.8.0/tzap-opt-x86_64-apple-darwin.tar.xz"
      sha256 "8cf4f99ac87f9f87c4498cf666ff42a63984a068007e938b0a8c4e4fb2190b26"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.8.0/tzap-opt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9f5204d4e858539ba4285e7b3562d3786a3730abb0620af04c88a73f8ff99eab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.8.0/tzap-opt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "eabd1919a31ea06a09e31745a99157ba4980e9516f9d1fa528d31ed4686c5a9f"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "tzap"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "tzap"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "tzap"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "tzap"
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
