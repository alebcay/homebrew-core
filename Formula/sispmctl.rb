class Sispmctl < Formula
  desc "Control Gembird SIS-PM programmable power outlet strips"
  homepage "https://sispmctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sispmctl/sispmctl/sispmctl-4.1/sispmctl-4.1.tar.gz"
  sha256 "bf5177e085cb0168e18e4cfb69645c3095da149ed46f5659d6e757bde3548e40"

  bottle do
    sha256 "cec81af9b77fc4c08d7530aac3aea21f0dcf85ae192428803815c80dc3b30e3a" => :mojave
    sha256 "3ad48ee1db3c177b4f93bedfa6163b0dafa96cfb1b1f349dc5d9682e78d67d98" => :high_sierra
    sha256 "c4e130a2484f40a4803e1eccac3c0411fde2c881b64a0220a60dede14bf9fdf7" => :sierra
    sha256 "4082f505586a99a70dc76516e505ca83d15d794a7c87a87629089d1c50ca44b9" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sispmctl -v 2>&1")
  end
end
