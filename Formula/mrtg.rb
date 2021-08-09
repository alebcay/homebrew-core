class Mrtg < Formula
  desc "Multi router traffic grapher"
  homepage "https://oss.oetiker.ch/mrtg/"
  url "https://oss.oetiker.ch/mrtg/pub/mrtg-2.17.8.tar.gz"
  sha256 "1ac2e0af69e0ecdef755e798ca59834ab78ac185c2a5effdb7685c58f2ef01b4"

  livecheck do
    url "https://oss.oetiker.ch/mrtg/pub/"
    regex(/href=.*?mrtg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "a1b3746893c8a50b75735a622cecdea8ae87d0ed4adaa18a9aadd473238fe271"
    sha256 cellar: :any,                 big_sur:       "657438ce4eea4830cd467cc64bd8f653b9a025e8052b6c1b5e8811bbd837cc91"
    sha256 cellar: :any,                 catalina:      "cae75a7387673aa555bf72112a1a00e24f9c2c87f87ffe2fcdf839c6b31a95ce"
    sha256 cellar: :any,                 mojave:        "cca3b58b58a453636d67bd041f56df487ce86eb7f592178bd9f8745e35e0f5f0"
    sha256 cellar: :any,                 high_sierra:   "8a76630f04f1c8b6883d7621cf9c72456e22fa5206a8b2b3eb6527547d048fbb"
    sha256 cellar: :any,                 sierra:        "71561d0dbd12007514597dc85bf8ecb5e76e32f0feb35eb126b0998a30db49c8"
    sha256 cellar: :any,                 el_capitan:    "0d434588f3d22e55db11fe23baa82a5e1a4a8ccbcab84dfd74ddc1a0dafc085c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a6c02386e4fbff691da189b7c81efb33fb4bc640556dddca7f3674b70e86bc9"
  end

  depends_on "gd"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cfgmaker", "--nointerfaces", "localhost"
  end
end
