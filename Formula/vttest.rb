class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20201225.tgz"
  sha256 "069db5efca2325280bc14ffe14ff7085e3ddfe6ae152499155daa28d94b90421"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "16cefda230b7a7bff904595e5a4b528d51c46096994a0d3077d7ae687ecdf0e5" => :big_sur
    sha256 "0782d07617d76ad09d71834cec53a1a647d4a72cf4b35065b8c4d60220d822f9" => :arm64_big_sur
    sha256 "18550bfedc0f4b511f56c564509b911b2a62a26b24e6b9d95093e44300be1ece" => :catalina
    sha256 "e3bda0ee8aa89fe4197dddb7fcddaf510424b929667a029a4c05a67824e0a46b" => :mojave
    sha256 "80644da812e6ee1c267ef9007ae5d1fb65538e732f18c1dc3851860a4e0495ad" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output(bin/"vttest -V")
  end
end
