class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "https://wiki.linuxfoundation.org/accessibility/"
  url "https://download.gnome.org/sources/at-spi2-atk/2.31/at-spi2-atk-2.31.2.tar.xz"
  sha256 "d82e5d54fd737bb258b75361d8493ac0fad011fce162e07032256aced635cbc2"

  bottle do
    cellar :any
    sha256 "c2027dd839ea861984aee1587108e89be54661d4ceada586a48b4ca4f6cd0d41" => :mojave
    sha256 "93b22bd8e17c750e71f8afbe96d2ed1011884f3a9461eeeeff7689b7473675ad" => :high_sierra
    sha256 "a017537217c5c1533adc6a9c2ed209349186380ccda808375d10a3e8d7b393ed" => :sierra
    sha256 "ac94ce79b4199253f019f7fd270e60931e2fbc301b86ec7e45aca16f58d0fc58" => :el_capitan
  end

  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "at-spi2-core"
  depends_on "atk"

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end
end
