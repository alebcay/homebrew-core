class Mill < Formula
  desc "Scala build tool"
  homepage "https://com-lihaoyi.github.io/mill/mill/Intro_to_Mill.html"
  url "https://github.com/com-lihaoyi/mill/releases/download/0.9.11/0.9.11-assembly"
  sha256 "a98c02b7bfbffc62472720eb67cadc18228bb2129e6c80c1402ca7eab2ce8494"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6343fb3d4280bf2944565dc8dbc3d4f01a1f9d7f66f68bb30dfea507fa914c46"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"].shift => "mill"
    chmod 0555, libexec/"mill"
    (bin/"mill").write_env_script libexec/"mill", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"build.sc").write <<~EOS
      import mill._
      import mill.scalalib._
      object foo extends ScalaModule {
        def scalaVersion = "2.12.8"
      }
    EOS
    output = shell_output("#{bin}/mill resolve __.compile")
    assert_equal "foo.compile", output.lines.last.chomp
  end
end
