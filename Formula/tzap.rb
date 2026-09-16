class Tzap < Formula
  desc "A super fast, Rust-based optimizer for large Clifford+T circuits"
  homepage "https://github.com/qqq-wisc/tzap"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.6.1/tzap-opt-aarch64-apple-darwin.tar.xz"
      sha256 "a6f35ef5b5393e0993d05a87405024b85fc2171dc4b75d583135c8ab6af72025"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.6.1/tzap-opt-x86_64-apple-darwin.tar.xz"
      sha256 "ed5234d7e4f4bf516c44cc499c1aa8b3676932d458df8f65630e52f518027cd2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.6.1/tzap-opt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "40ec796bfb2544d728537c542e659974c584b672db20669d9f57463c6012e9a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.6.1/tzap-opt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c3b30e74a787a28b150b75b83cbf266a60183b9b831653660619a2b7e716486"
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
