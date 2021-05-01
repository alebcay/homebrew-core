class Pngcheck < Formula
  desc "Print info and check PNG, JNG, and MNG files"
  homepage "http://www.libpng.org/pub/png/apps/pngcheck.html"
  url "http://www.libpng.org/pub/png/src/pngcheck-3.0.3.tar.gz"
  sha256 "c36a4491634af751f7798ea421321642f9590faa032eccb0dd5fb4533609dee6"
  license all_of: ["MIT", "GPL-2.0-or-later"]

  livecheck do
    url :homepage
    regex(/href=.*?pngcheck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c188297adf8fb8a9d17c90aba9036287e3dc1578ff5343e8efbccd0936e888e0"
    sha256 cellar: :any_skip_relocation, big_sur:       "3440f1f335a0bd2ddffe9a30b0186bc19085f9fb83bfa80a81ba9f3c143d9641"
    sha256 cellar: :any_skip_relocation, catalina:      "a771117cbf3b11ec082ceaaa62ae6ed14f57e77cafb8b62f8bf9959e265274b6"
    sha256 cellar: :any_skip_relocation, mojave:        "83edeec573d0aa0032cf4f242d9c5b15462678da50c80dd922c4254a22b7ae16"
  end

  uses_from_macos "zlib"

  def install
    system "make", "-f", "Makefile.unx", "ZINC=", "ZLIB=-lz"
    bin.install %w[pngcheck pngsplit png-fix-IDAT-windowsize]
  end

  test do
    system bin/"pngcheck", test_fixtures("test.png")
  end
end
