class Tzap < Formula
  desc "A super fast, Rust-based optimizer for large Clifford+T circuits"
  homepage "https://github.com/qqq-wisc/tzap"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.7.0/tzap-opt-aarch64-apple-darwin.tar.xz"
      sha256 "47c0f9bcad722acca2f8f85e15a16007ea02322511bd58854e2ba4155f9d0a61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.7.0/tzap-opt-x86_64-apple-darwin.tar.xz"
      sha256 "dd7073880e3e5fde1ddacaef2b2b76b812c874580edb624de0b16ecad9b25603"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.7.0/tzap-opt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7e952b608809fc5fb474983c4e1f46decbea58c742c6bf0cc26b60000da0f51a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.7.0/tzap-opt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3b1758c95d2ff81fef99ad3d12c4a5e4ece0b7b992488516ed1aa9c8a86c0caf"
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
