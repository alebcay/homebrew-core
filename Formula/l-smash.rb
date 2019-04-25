class LSmash < Formula
  desc "Tool for working with MP4 files"
  homepage "https://l-smash.github.io/l-smash/"
  url "https://github.com/l-smash/l-smash.git",
      :shallow  => false,
      :tag      => "v2.14.5",
      :revision => "5b85a6bf9ca8924144bd3026b17355638a6b7430"
  head "https://github.com/l-smash/l-smash.git"

  bottle do
    cellar :any
    sha256 "811e696583af5a78ec288d46f8815d5a5db246f335d2ba2e0d4f3fce9a98e2a2" => :mojave
    sha256 "eae1dfce4f50c3b48d2a3fabf415ad7ec98de0937d610fec98d700e517e18934" => :high_sierra
    sha256 "57802892865529a99658bd4da1b29eb5287259183658131cc215ef80fcd0cfbe" => :sierra
    sha256 "5751796e42e7d544f4976bc304a0ae7407dc5217b2b4218b0a6afdc18ea3eeaf" => :el_capitan
    sha256 "3703bdeb1dfe66aef898e60a990f4e64f0ab3c1fe26a49cf824b3c6998acaacc" => :yosemite
    sha256 "78c5c52a90e1609694b43a45240126515f97be8a1d129a57215d4a7ba9e3717f" => :mavericks
  end

  patch do
    url "https://github.com/l-smash/l-smash/commit/18f7ef3111ba08b48996a655103e164694b5ddf9.patch?full_index=1"
    sha256 "cd209113a2ab6bb725fe40a8b793b5751919ad523f0708e1184cdf18711d6c5a"
  end

  patch do
    url "https://github.com/l-smash/l-smash/commit/86c764a96d8173d91b7321b6a72ad3bc1b2be413.patch?full_index=1"
    sha256 "4b40c9dc8fbb52ec8510d429b235f5eed153ce474d5344bac46b1096dcb41908"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-shared"
    system "make", "install"
  end

  test do
    system bin/"boxdumper", "-v"
    system bin/"muxer", "-v"
    system bin/"remuxer", "-v"
    system bin/"timelineeditor", "-v"
  end
end
