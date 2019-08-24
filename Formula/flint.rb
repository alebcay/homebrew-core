class Flint < Formula
  desc "Fast Library for Number Theory"
  homepage "http://flintlib.org"
  url "http://flintlib.org/flint-2.5.2.tar.gz"
  sha256 "cbf1fe0034533c53c5c41761017065f85207a1b770483e98b2392315f6575e87"

  depends_on "gmp"
  depends_on "mpfr"

  def install
    ENV["DYLD_LIBRARY_PATH"] = "/System/Library/Frameworks/ImageIO.framework/Versions/A/Resources/"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    (pkgshare/"test").install "examples/radix.c"
  end

  test do
    system ENV.cc, pkgshare/"test/radix.c", "-I#{include}/flint", "-L#{lib}", "-L#{Formula["gmp"].lib}", "-lflint", "-lgmp", "-o", "test"
    system "./test"
  end
end
