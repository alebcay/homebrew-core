class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://eclipse.org/aspectj/"
  url "https://www.eclipse.org/downloads/download.php?r=1&file=/tools/aspectj/aspectj-1.9.5.jar"
  sha256 "335820a6772587873dfdcc614a772ecbb4731b4ffb99eb8ad953cde39f9cf825"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    mkdir_p "#{libexec}/#{name}"
    system "java", "-jar", "aspectj-#{version}.jar", "-to", "#{libexec}/#{name}"
    bin.install Dir["#{libexec}/#{name}/bin/*"]
    bin.env_script_all_files(libexec/"#{name}/bin", Language::Java.java_home_env("1.8"))
    chmod 0555, Dir["#{libexec}/#{name}/bin/*"] # avoid 0777
  end

  test do
    (testpath/"Test.java").write <<~EOS
      public class Test {
        public static void main (String[] args) {
          System.out.println("Brew Test");
        }
      }
    EOS
    (testpath/"TestAspect.aj").write <<~EOS
      public aspect TestAspect {
        private pointcut mainMethod () :
          execution(public static void main(String[]));

          before () : mainMethod() {
            System.out.print("Aspect ");
          }
      }
    EOS
    ENV["CLASSPATH"] = "#{libexec}/#{name}/lib/aspectjrt.jar:test.jar:testaspect.jar"
    system bin/"ajc", "-outjar", "test.jar", "Test.java"
    system bin/"ajc", "-outjar", "testaspect.jar", "-outxml", "TestAspect.aj"
    output = shell_output("#{bin}/aj Test")
    assert_match /Aspect Brew Test/, output
  end
end
