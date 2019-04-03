class Libks < Formula
  desc "Foundational support for signalwire C products"
  homepage "https://github.com/signalwire/libks"
  url "https://files.freeswitch.org/downloads/libs/libks-1.1.0.tar.gz"
  sha256 "df685ad4374b2e6196fb5c28013a9fd1effe4a3a18b999f7633711713546b858"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "ossp-uuid"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    cd "tests" do
      mkdir_p pkgshare/"tests"
      (pkgshare/"tests").install "testacl"
      (pkgshare/"tests").install "testlog"
      (pkgshare/"tests").install "testpools"
      (pkgshare/"tests").install "testrealloc"
      (pkgshare/"tests").install "teststring"
      (pkgshare/"tests").install "testthreadmutex"
      (pkgshare/"tests").install "testtime"
      (pkgshare/"tests").install "testwebsock"
    end
  end

  test do
    Dir["#{pkgshare/"tests"}/test*"].each do |fname|
      system fname
    end
  end
end
