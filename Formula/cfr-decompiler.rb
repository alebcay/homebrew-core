class CfrDecompiler < Formula
  desc "Yet Another Java Decompiler"
  homepage "https://www.benf.org/other/cfr/"
  url "https://www.benf.org/other/cfr/cfr-0.149.jar"
  sha256 "db683b5b3bc2c20fd2fabcc9d749d5b8bcbba736f334e5ac2092173242967aca"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "cfr-#{version}.jar"
    (bin/"cfr-decompiler").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
      exec "${JAVA_HOME}/bin/java" -jar "#{libexec}/cfr-#{version}.jar" "$@"
    EOS
  end

  test do
    fixture = <<~EOS
      import java.io.PrintStream;

      class T {
          T() {
          }

          public static void main(String[] arrstring) {
              System.out.println("Hello brew!");
          }
      }
    EOS
    (testpath/"T.java").write fixture
    system "#{Formula["openjdk"].bin}/javac", "T.java"
    output = pipe_output("#{bin}/cfr-decompiler T.class")
    assert_match fixture, output
  end
end
