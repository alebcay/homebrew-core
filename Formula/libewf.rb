class Libewf < Formula
  desc "Library for support of the Expert Witness Compression Format"
  homepage "https://github.com/libyal/libewf"
  url "https://deb.debian.org/debian/pool/main/libe/libewf/libewf_20171104.orig.tar.gz"
  version "20171104"
  sha256 "cf36d3baf3a96dbe566fde55ae7d79fc2e7b998806ab13e0f69915799f19e040"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7fe79d5c0cbbc77727528df3effaeb9e6cb85f041f3183aed7e288c572142bd4" => :mojave
    sha256 "a8598eb679b9a0abfb4ced4845cc21835101bcb47f909c0bf217a7211dc8d67a" => :high_sierra
    sha256 "9070532ca601a8d020a1de5ccca0e7613788afb696b4ffd7efcad652c7b77d7c" => :sierra
  end

  head do
    url "https://github.com/libyal/libewf.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    if build.head?
      system "./synclibs.sh"
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-libfuse=no
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ewfinfo -V")
  end
end
