class SignalwireClientC < Formula
  desc "C client library for signalwire"
  homepage "https://github.com/signalwire/signalwire-c"
  url "https://files.freeswitch.org/downloads/libs/signalwire-client-c-1.0.0.tar.gz"
  sha256 "85b0493a2332b2f763a8a2f92f4e9905c7d9c49eb4be4218f5aa99b87a28dbce"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libks"
  depends_on "openssl"
  depends_on "ossp-uuid"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    cd "examples/client" do
      system ENV.cc, "-I#{include}", "-L#{lib}", "-lsignalwire_client", "main.c", "-o", "test"
      pkgshare.install "test"
    end
  end

  test do
    system pkgshare/"test"
  end
end
