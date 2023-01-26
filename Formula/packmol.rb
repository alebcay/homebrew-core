class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/v20.14.0.tar.gz"
  sha256 "dc39d3c8676c48cf4999a864e902532b664063c616aeecae1962d37478c5a30c"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dccfdd30381bb3eaa77400be1243d01eb15f1320282410206ca44915fba7a260"
    sha256 cellar: :any,                 arm64_monterey: "7516aacdd467dbd9e0495cb18f852ed8937ecc41e5512161e22f708546735ff6"
    sha256 cellar: :any,                 arm64_big_sur:  "2eac2ee152212c80ecfaf76449c23b1cb68d1608bae14d71889b890656994027"
    sha256                               ventura:        "078ab69ac5c3ade1b1d3d436f7b9522e34a5c9ec1f272ce60b8d3d9508f08d79"
    sha256                               monterey:       "7786e64e173b5f76706b6e303ada991a8dcdb563fa6bb163c295e945017c6d63"
    sha256                               big_sur:        "51378edfd5b099f2ad1475c89e30a76e19efd5ebe88771614a9247ad909a0215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e6ec13d87c4c8e7c9c609772f7e743dcaeda13f3979aa14103ee8d0564feb57"
  end

  depends_on "gcc" # for gfortran

  resource "homebrew-testdata" do
    url "https://www.ime.unicamp.br/~martinez/packmol/examples/examples.tar.gz"
    sha256 "97ae64bf5833827320a8ab4ac39ce56138889f320c7782a64cd00cdfea1cf422"
  end

  def install
    # Avoid passing -march=native to gfortran
    inreplace "Makefile", "-march=native", ENV["HOMEBREW_OPTFLAGS"] if build.bottle?

    system "./configure"
    system "make"
    bin.install "packmol"
    pkgshare.install "solvate.tcl"
    (pkgshare/"examples").install resource("homebrew-testdata")
  end

  test do
    cp Dir["#{pkgshare}/examples/*"], testpath
    system bin/"packmol < interface.inp"
  end
end
