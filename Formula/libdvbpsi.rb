class Libdvbpsi < Formula
  desc "Library to decode/generate MPEG TS and DVB PSI tables"
  homepage "https://www.videolan.org/developers/libdvbpsi.html"
  url "https://get.videolan.org/libdvbpsi/1.3.3/libdvbpsi-1.3.3.tar.bz2"
  mirror "https://download.videolan.org/pub/libdvbpsi/1.3.3/libdvbpsi-1.3.3.tar.bz2"
  sha256 "02b5998bcf289cdfbd8757bedd5987e681309b0a25b3ffe6cebae599f7a00112"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.videolan.org/pub/libdvbpsi/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b10d05a1a32a329126bf588f77962518e48a459cb4354881757db39538df3e76"
    sha256 cellar: :any,                 arm64_monterey: "0f7e72f47f7677017fd3a003b0ef61d7d161fdaaf673adefd5a64fb3f83d8a40"
    sha256 cellar: :any,                 arm64_big_sur:  "a61aaac7ff201fdd38a929556c6a64a69993150891690f8ea9532e1b9c9c9ae3"
    sha256 cellar: :any,                 ventura:        "541072af239fb15bfe435724a85fe273a391e394913c9b73167f0de542003991"
    sha256 cellar: :any,                 monterey:       "16bdd90a4f0734be90ab9e7c0a955913f07ee21dc41cf91666be43301661b1a4"
    sha256 cellar: :any,                 big_sur:        "255b960c43fac14b8a50af513ca3b2925cdfa0e71efa61d2eced2fd172fe8dff"
    sha256 cellar: :any,                 catalina:       "b6e6f300bbc36fabf785f74abb083c5cfc3f91fdd51ee7bd058cc579e709c78d"
    sha256 cellar: :any,                 mojave:         "26298540d01f52628385c83cac4b6666543af4cc059fa7ad5b3a8bd458955628"
    sha256 cellar: :any,                 high_sierra:    "c6d79686bf05346bc473cc148b68901d99ac447a85542ff68d089c71eda1bc87"
    sha256 cellar: :any,                 sierra:         "8bb1f1fff61674756153e8aec744d5d3c726da0c4ecd4bd291cae732e8264af3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47a182099c4d84323f3058738f29b1668f364d7e16c214777bae6bcd9f257b24"
  end

  head do
    url "https://code.videolan.org/videolan/libdvbpsi.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  resource "homebrew-sample-ts" do
    url "https://filesamples.com/samples/video/ts/sample_640x360.ts"
    sha256 "64804df9d209528587e44d6ea49b72f74577fbe64334829de4e22f1f45c5074c"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-release"
    system "make", "install"
    pkgshare.install "examples/dump_pids.c"
  end

  test do
    # Adjust headers to allow the test to build without the upstream source tree
    cp pkgshare/"dump_pids.c", testpath/"test.c"
    inreplace "test.c",
              "#include \"config.h\"\n",
              "#include <inttypes.h>\n"

    system ENV.cc, testpath/"test.c", "-I#{include}", "-L#{lib}", "-ldvbpsi", "-o", "test"

    resource("homebrew-sample-ts").stage do
      output = shell_output("#{testpath}/test sample_640x360.ts")

      assert_equal 3440, output.lines.length
      output.lines.each do |line|
        assert_match(/^packet \d+, pid \d+ \(0x\d+\), cc \d+$/, line)
      end
    end
  end
end
