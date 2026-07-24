class Tzap < Formula
  desc "A super fast, Rust-based optimizer for large Clifford+T circuits"
  homepage "https://github.com/qqq-wisc/tzap"
  version "0.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.4.3/tzap-opt-aarch64-apple-darwin.tar.xz"
      sha256 "400892022c23690fe6b36848dd282b2810f24922246cbc9d10ab580a0d463a22"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.4.3/tzap-opt-x86_64-apple-darwin.tar.xz"
      sha256 "23f5605a459c1e3af526a87b27fe2761a0a5fc3776ae38abfaed0ceed492ea26"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.4.3/tzap-opt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "261f4374ac2109eb3b001dda5ed43b48d575fbee661f5e3d5ba8c81af1e2e1e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/qqq-wisc/tzap/releases/download/v0.4.3/tzap-opt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "da0a7fc5846b94d3200615a9289fef4a6bfe5b7696642ba8ec7dfb2d21e0a518"
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
