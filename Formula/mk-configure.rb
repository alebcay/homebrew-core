class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.32.1/mk-configure-0.32.1.tar.gz"
  sha256 "0b9d9b409e6eb7d3820c64a972078f4380697c68abafee7ec16a7eb74cf2eb9e"

  bottle do
    cellar :any_skip_relocation
    sha256 "211fa03580498d11d9086e21fb9908b1c48d606487874aca7dc1876ca9d6c41c" => :catalina
    sha256 "3c6dde9e73c409690bc2e5dee76c0509c8ae0d7fd34bf155e3f63297f9af9e9b" => :mojave
    sha256 "3c6dde9e73c409690bc2e5dee76c0509c8ae0d7fd34bf155e3f63297f9af9e9b" => :high_sierra
    sha256 "f8a80216317e5d7e3ed3c412114b1ee58b2250a2c019bf99ca25686cb7d07547" => :sierra
  end

  depends_on "bmake"
  depends_on "makedepend"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man

    system "bmake", "all"
    system "bmake", "install"
    doc.install "presentation/presentation.pdf"
  end

  test do
    system "#{bin}/mkcmake", "-V", "MAKE_VERSION", "-f", "/dev/null"
  end
end
