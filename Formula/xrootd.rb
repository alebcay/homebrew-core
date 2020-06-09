class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v4.12.2/xrootd-4.12.2.tar.gz"
  sha256 "29f7bc3ea51b9d5d310eabd177152245d4160223325933c67f938ed5120f67bb"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    sha256 "0a96817477e154abf8d79661fa509ce29ef8104bb9f60248b902451443f8a695" => :catalina
    sha256 "00298c78468eb6c52989d8e11c6a162f6a6479102d879c316a9aa2e0a7c3ef1e" => :mojave
    sha256 "49c07776c1af8749bed718202e92ba17ea00fd71ade4b5c3c96918dcd6e989b0" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_PYTHON=OFF"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
