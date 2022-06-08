class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.19.tar.gz"
  sha256 "293e796589cf3dd24404973c67bace3d80b2f44c41c9f04531cb7e4b445431b9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ce524ac59c91bf7942ae0f70e33b3651d49fa3ecd356ae2f06f1be4e4b02854"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94b8292dac877a62c85f369f6494efe2583a4c23c814548bb790efa5e90f8d46"
    sha256 cellar: :any_skip_relocation, monterey:       "cac1153b0980d8bd50e01eccf273276cc233fcf8857bef2cee8e3637b4eb9d34"
    sha256 cellar: :any_skip_relocation, big_sur:        "eee798c80d935fe1c2fc5e97c1e1e83d05d66318de722ec569caf3fdbd2f1609"
    sha256 cellar: :any_skip_relocation, catalina:       "41879986ca052a7e39f6f9e6ce2ea4b6d7d3061bf0b0d1eee7ae1d6a3e4396f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "599ed442e6c2f4c2188f9d90e78c90c1d9ddbd8a030284fd10fe38814404d70a"
  end

  depends_on "python@3.10" => :test
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"maturin", "completions", "bash")
    (bash_completion/"maturin").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"maturin", "completions", "zsh")
    (zsh_completion/"_maturin").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"maturin", "completions", "fish")
    (fish_completion/"maturin.fish").write fish_output
  end

  test do
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_bin
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    system "python3", "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system "python3", "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
