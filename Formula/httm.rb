class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.20.0.tar.gz"
  sha256 "42d92e02383389afc9594b62cbc319f98528abcc5a5e69cda840c6469bdbda2b"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3465c00afd75668edff03bde0dee5d7e15df3eb27b63b25f03e01a463f8c197"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43f0cc508951bf5330c2de800a93224fc96e6622edfe1f7498d35b30707e8ded"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f90a8440accea1973ef06d0e007829978d161461909e9f550889901b362096ca"
    sha256 cellar: :any_skip_relocation, ventura:        "0c7860dc7f05c95e9fde06816cf08208ece95592a562ec5c9bf42d5d4e019be3"
    sha256 cellar: :any_skip_relocation, monterey:       "34fbc6444e8715c5d1485384a31bfb7479c2be3438dbe4e5f7061085f15287d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "d317289562714c04b2206fa7525d23a7e2ee0e09cac85808a2e38c51c8b2262d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1241b04a361fc83a9c9e7d812868af5376e053f9e907db941b64d7e907ea1f6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
