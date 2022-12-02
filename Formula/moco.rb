class Moco < Formula
  desc "Stub server with Maven, Gradle, Scala, and shell integration"
  homepage "https://github.com/dreamhead/moco"
  url "https://search.maven.org/remotecontent?filepath=com/github/dreamhead/moco-runner/1.4.0/moco-runner-1.4.0-standalone.jar"
  sha256 "c51892b292fdcf37cf69368625adfa22f9a851b931bc89142933a2754ca167d7"
  license "MIT"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/github/dreamhead/moco-runner/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "257b2db7c5b9aa5a9794d97b85294c7a9fc4e44bae17ed074acccfeb36ede90f"
  end

  depends_on "openjdk"

  def install
    libexec.install "moco-runner-#{version}-standalone.jar"
    bin.write_jar_script libexec/"moco-runner-#{version}-standalone.jar", "moco"
  end

  test do
    (testpath/"config.json").write <<~EOS
      [
        {
          "response" :
          {
              "text" : "Hello, Moco"
          }
        }
      ]
    EOS

    port = free_port
    begin
      pid = fork do
        exec "#{bin}/moco http -p #{port} -c #{testpath}/config.json"
      end
      sleep 10

      assert_match "Hello, Moco", shell_output("curl -s http://127.0.0.1:#{port}")
    ensure
      Process.kill "SIGTERM", pid
      Process.wait pid
    end
  end
end
