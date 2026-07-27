class Tzap < Formula
  desc "A super fast, Rust-based optimizer for large Clifford+T circuits"
  homepage "https://github.com/qqq-wisc/tzap"
  version "0.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.4.4/tzap-opt-aarch64-apple-darwin.tar.xz"
      sha256 "bb86fc37e1982bbfad235a176a1a275738b93336fef72a370554132e3902f54e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.4.4/tzap-opt-x86_64-apple-darwin.tar.xz"
      sha256 "f5fdacc1f1b7ae6dbf942adba4aa5ec072dc44780c878ccb0cc3b55198d14758"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.4.4/tzap-opt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9a4669c20b74fad91e47760eaf3bcafd4cd3706108a0071a4b3e3868833d81e2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.4.4/tzap-opt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6652c7e8a0d2099d0b6707e7fc61821604140161f9654b3dc8026f7c48d53a63"
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
