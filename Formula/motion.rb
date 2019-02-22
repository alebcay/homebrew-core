class Motion < Formula
  desc "Software motion detector"
  homepage "https://motion-project.github.io/"
  url "https://github.com/Motion-Project/motion/archive/release-4.2.2.tar.gz"
  sha256 "c8d40976b41da8eb9f9f7128599403a312fc26b7226bf3787d75f78cb5a6cc6e"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "gettext"
  depends_on "jpeg"
  depends_on "libmicrohttpd"
  depends_on "webp"

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--without-pgsql",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    mv prefix/"etc/motion/motion-dist.conf", prefix/"etc/motion/motion.conf"
  end

  test do
    run_output = shell_output("#{bin}/motion -h", 1)
    assert_match "motion Version #{version}", run_output
  end
end
