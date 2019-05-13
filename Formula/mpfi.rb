class Mpfi < Formula
  desc "Multiple precision interval arithmetic library"
  homepage "https://perso.ens-lyon.fr/nathalie.revol/software.html"
  url "https://gforge.inria.fr/frs/download.php/file/37706/mpfi-1.5.4.tar.gz"
  sha256 "76b01b9eed7150a44b3f6aea24ad4ac78b0f2078253be87ff6d1903d02dfa434"

  bottle do
    cellar :any
    rebuild 1
    sha256 "55d8819c0310e6b8bc66742f7ab5881b9b552a9c60eaf940595ed08e8a320a56" => :mojave
    sha256 "d4464bdbbb2861861fa92e471f75e1b658e7c5f5814028a6c57f74c76092b013" => :high_sierra
    sha256 "50d3b78c1ef6837198a0320dbbe0852ad524f83bc2e12460bfbdc188bd1da76a" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gmp"
  depends_on "mpfr"

  def install
    cd "mpfi" do
      system "./autogen.sh"
      system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
      system "make"
      system "make", "check"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mpfi.h>

      int main()
      {
        mpfi_t x;
        mpfi_init(x);
        mpfi_clear(x);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test",
                   "-L#{lib}", "-lmpfi",
                   "-L#{Formula["mpfr"].lib}", "-lmpfr",
                   "-L#{Formula["gmp"].lib}", "-lgmp"
    system "./test"
  end
end
