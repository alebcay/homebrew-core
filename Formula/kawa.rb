class Kawa < Formula
  desc "Programming language for Java (implementation of Scheme)"
  homepage "https://www.gnu.org/software/kawa/"
  url "https://ftp.gnu.org/gnu/kawa/kawa-3.1.1.zip"
  mirror "https://ftpmirror.gnu.org/kawa/kawa-3.1.1.zip"
  sha256 "dab1f41da968191fc68be856f133e3d02ce65d2dbd577a27e0490f18ca00fa22"
  license "MIT"
  revision 2

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"]
    inreplace "bin/kawa", "thisfile=`command -v $0`",
                          "thisfile=#{libexec}/bin/kawa"
    libexec.install "bin", "lib"
    (bin/"kawa").write_env_script libexec/"bin/kawa", Language::Java.overridable_java_home_env
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"kawa", "-e", "(import (srfi 1))"
  end
end
