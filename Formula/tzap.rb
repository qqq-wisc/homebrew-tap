class Tzap < Formula
  desc "A super fast, Rust-based optimizer for large Clifford+T circuits"
  homepage "https://github.com/qqq-wisc/tzap"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.5.0/tzap-opt-aarch64-apple-darwin.tar.xz"
      sha256 "850fadc9509fee6f4b5e0edf4d6c83ae8fd2448aa0e51bbdb5622499c4eba7d1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.5.0/tzap-opt-x86_64-apple-darwin.tar.xz"
      sha256 "9a794d67b72c0ac981fdb8267ebc1220d9b86a84df3bf4f08d1beb45852fbece"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.5.0/tzap-opt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5f810486740c30618d21dee3552526f70c9af5f09f18df1d86c46e7dd8dda4f4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.5.0/tzap-opt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4e11af5ed52dd25d285d983f5c804d4978eb50f4424850246af66b648697165a"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
