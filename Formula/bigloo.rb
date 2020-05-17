class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo4.3h.tar.gz"
  version "4.3h"
  sha256 "2f6e74ed84acc109e5c46c1e7601043176ed6d8bf64666995015396d1240803b"

  bottle do
    sha256 "06c2d3728e778db36954a6fca8ecc8cb663d90122a884cfb0fc96ce1de36663a" => :catalina
    sha256 "5de69de8a1afee85a7b6af5d024c80ff3ceb7acc8e391c20fd24398122cfad9a" => :mojave
    sha256 "26a5f98ee71f7794ced067f64a695f040ef271413ac58b0e0cbfa883ab44ee73" => :high_sierra
    sha256 "2844e66dfeecc9cfe4ad85558f2d2be450b5aea3acad7461402e9fcb7fb5bbdd" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gmp"
  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man1}
      --infodir=#{info}
      --customgc=yes
      --os-macosx
      --native=yes
      --disable-alsa
      --disable-mpg123
      --disable-flac
      --disable-srfi27
      --jvm=yes
    ]

    system "./configure", *args
    system "make"
    system "make", "install"

    # gmp and libunistring info files will conflict with gmp and libunistring formulae
    rm Dir["#{info}/{gmp,libunistring}.*"]

    # Install the other manpages too
    manpages = %w[bgldepend bglmake bglpp bgltags bglafile bgljfile bglmco bglprof]
    manpages.each { |m| man1.install "manuals/#{m}.man" => "#{m}.1" }
  end

  test do
    program = <<~EOS
      (display "Hello World!")
      (newline)
      (exit)
    EOS
    assert_match "Hello World!\n", pipe_output("#{bin}/bigloo -i -", program)
  end
end
