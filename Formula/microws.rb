class Microws < Formula
  desc "Tiny WebSockets"
  homepage "https://github.com/uNetworking/uWebSockets"
  url "https://github.com/uNetworking/uWebSockets/archive/v0.14.4.tar.gz"
  sha256 "9d7854fe3b8c43903957ccd9001e954e210e14a0545549515a9f020bf275c4fc"

  depends_on "libuv"
  depends_on "openssl"

  def install
    system "make", "Darwin"
    (include/"uWS").install Dir["src/*.h"]
    lib.install "libuWS.dylib"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <uWS/uWS.h>

      int main()
      {
          uWS::Hub h;

          h.onMessage([](uWS::WebSocket<uWS::SERVER> *ws, char *message, size_t length, uWS::OpCode opCode) {
              ws->send(message, length, opCode);
          });

          if (h.listen(3000)) {
            exit(0);
          } else {
            exit(1);
          }
      }
    EOS
    system ENV.cxx, "--std=c++14",
                    "-I#{Formula["openssl"].include}", "-L#{Formula["openssl"].lib}", "-lssl",
                    "-I#{Formula["microws"].include}", "-L#{Formula["microws"].lib}", "-luws",
                    "-I#{Formula["libuv"].include}", "-L#{Formula["libuv"].lib}", "-luv",
                    "-lz", "test.cpp", "-o", "test"
    system testpath/"test"
  end
end
