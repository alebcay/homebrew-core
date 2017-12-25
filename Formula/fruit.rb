class Fruit < Formula
  desc "Fruit, a dependency injection framework for C++"
  homepage "https://github.com/google/fruit/wiki"
  url "https://github.com/google/fruit/archive/v3.1.0.tar.gz"
  sha256 "d3307e02b8c85421290fc0c748ef2f964a9313596f963ae14176f35674d7230c"

  depends_on "boost" => :optional
  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DFRUIT_USES_BOOST=False" if build.without? "boost"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fruit/fruit.h>
      #include <iostream>

      using fruit::Component;
      using fruit::Injector;

      class Writer {
      public:
        virtual void write(std::string s) = 0;
      };

      class StdoutWriter : public Writer {
      public:
        // Like "StdoutWriter() = default;" but also marks this constructor as the
        // one to use for injection.
        INJECT(StdoutWriter()) = default;
        virtual void write(std::string s) override {
          std::cout << s;
        }
      };

      class Greeter {
      public:
        virtual void greet() = 0;
      };

      class GreeterImpl : public Greeter {
      private:
        Writer* writer;

      public:
        // Like "GreeterImpl(Writer* writer) {...}" but also marks this constructor
        // as the one to use for injection.
        INJECT(GreeterImpl(Writer* writer))
          : writer(writer) {
        }
        virtual void greet() override {
          writer->write("Hello world!\\n");
        }
      };

      Component<Greeter> getGreeterComponent() {
        return fruit::createComponent()
          .bind<Writer, StdoutWriter>()
          .bind<Greeter, GreeterImpl>();
      }

      int main() {

        Injector<Greeter> injector(getGreeterComponent);
        Greeter* greeter = injector.get<Greeter*>();
        greeter->greet();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{Formula["fruit"].opt_prefix}/include", "-L#{Formula["fruit"].opt_prefix}/lib", "-std=c++11", "-lfruit", "-o", "test"
    system "#{testpath}/test"
  end
end
