class Libcork < Formula
  desc "Simple, easily embeddable cross-platform C library"
  homepage "https://libcork.io"
  url "https://github.com/dcreager/libcork.git",
      :tag      => "0.15.0",
      :revision => "d6ecc2cfbcdf5013038a72b4544f7d9e6eb8f92d"
  depends_on "check" => :build
  depends_on "cmake" => :build

  def install
    mkdir_p "build"
    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
      (pkgshare/"tests").install Dir["tests/embedded-test-*"]
    end
  end

  test do
    Dir.foreach(pkgshare/"tests") do |item|
      next if (item == ".") || (item == "..")

      system pkgshare/"tests"/item
    end
  end
end
