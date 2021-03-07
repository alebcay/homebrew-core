class Ntl < Formula
  desc "C++ number theory library"
  homepage "https://libntl.org"
  url "https://libntl.org/ntl-11.4.4.tar.gz"
  sha256 "9d7f6e82e11a409f151c0de2deb08c0d763baf9834fddfd432bf3d218f8021db"

  livecheck do
    url "https://libntl.org/download.html"
    regex(/href=.*?ntl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "145c34c0546556702339547567005c511610875f6817a49ccc8c08eda9cc1086"
    sha256 cellar: :any, big_sur:       "9e02780202c0a4b9b65080df3a731347b2f8fc1cfdeb4073d68440acba012ecd"
    sha256 cellar: :any, catalina:      "fc44a358782565b05098a29f2694fe16100c2b5aa096c04875edd093adf78b5d"
    sha256 cellar: :any, mojave:        "d0739cc2ebea1427d1fae3b0f871105b69d6f9c4c765415ed2f328af1e925598"
    sha256 cellar: :any, high_sierra:   "5747add8bf85ae5a46d8c12635efbf61a2b5c402e35fdaebcf7499148c682564"
  end

  depends_on "gmp"

  def install
    args = ["PREFIX=#{prefix}", "SHARED=on"]

    cd "src" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"square.cc").write <<~EOS
      #include <iostream>
      #include <NTL/ZZ.h>

      int main()
      {
          NTL::ZZ a;
          std::cin >> a;
          std::cout << NTL::power(a, 2);
          return 0;
      }
    EOS
    gmp = Formula["gmp"]
    flags = %W[
      -std=c++11
      -I#{include}
      -L#{gmp.opt_lib}
      -L#{lib}
      -lntl
      -lgmp
    ]
    system ENV.cxx, "square.cc", "-o", "square", *flags
    assert_equal "4611686018427387904", pipe_output("./square", "2147483648")
  end
end
