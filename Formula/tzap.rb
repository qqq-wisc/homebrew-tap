class Tzap < Formula
  desc "A super fast, Rust-based optimizer for large Clifford+T circuits"
  homepage "https://github.com/qqq-wisc/tzap"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.6.0/tzap-opt-aarch64-apple-darwin.tar.xz"
      sha256 "87e1847fcbeefd9eb7a77c4495cfac6043e0dad531b40dcb4385c20782bee963"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.6.0/tzap-opt-x86_64-apple-darwin.tar.xz"
      sha256 "5a4d948a8c2decd0c321c2d0c632e1a2a854a435a8c7a78b708342fd3b9bc7a7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.6.0/tzap-opt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ca798d74b57f2bc86e286805a258d58963a50be26b1ed5ba7edc093cbb0c500b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.6.0/tzap-opt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1051f559ca6ad56e2ba35d451347e05e77e08c5e4e1422729cb698a1e0b6abe9"
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
