class Umple < Formula
  desc "Modeling tool/programming language that enables Model-Oriented Programming"
  homepage "https://www.umple.org"
  url "https://github.com/umple/umple/releases/download/v1.32.1/umple-1.32.1.6535.66c005ced.jar"
  version "1.32.1"
  sha256 "fb2555ffef27ff6073365dc37f8672a6d254a258323441bda6015d4789e78f45"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "59b672bd1080c3e1639c38590af8cd58a755f4ee118935ad14801c4a142190ac"
  end

  depends_on "openjdk"

  def install
    filename = File.basename(stable.url)

    libexec.install filename
    bin.write_jar_script libexec/filename, "umple"
  end

  test do
    (testpath/"test.ump").write("class X{ a; }")
    system "#{bin}/umple", "test.ump", "-c", "-"
    assert_predicate testpath/"X.java", :exist?
    assert_predicate testpath/"X.class", :exist?
  end
end
