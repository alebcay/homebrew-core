class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.6.0/typedb-all-mac-2.6.0.zip"
  sha256 "770ec5c4f543873c8db92fa923902e30d24cd1d991f6ba44eead889361d549a7"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c3d3ead692d5963f807280528ccd8e78d6f37d2a3230cb4c9442a31c44c49a1b"
    sha256 cellar: :any_skip_relocation, big_sur:       "c3d3ead692d5963f807280528ccd8e78d6f37d2a3230cb4c9442a31c44c49a1b"
    sha256 cellar: :any_skip_relocation, catalina:      "c3d3ead692d5963f807280528ccd8e78d6f37d2a3230cb4c9442a31c44c49a1b"
    sha256 cellar: :any_skip_relocation, mojave:        "c3d3ead692d5963f807280528ccd8e78d6f37d2a3230cb4c9442a31c44c49a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "899d7b2dbbfba0279aed9df963356dae18c0624490a1232062e603fc3efbe435"
  end

  depends_on arch: :x86_64
  depends_on "openjdk@11"

  uses_from_macos "netcat" => :test

  def install
    libexec.install Dir["*"]
    bin.install libexec/"typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env("11"))
  end

  test do
    port = free_port
    mkdir "data"
    mkdir "logs"
    fork do
      exec bin/"typedb", "server", "--server.address=localhost:#{port}",
           "--storage.data=#{testpath}/data", "--log.output.file.directory=#{testpath}/logs"
    end
    sleep 10

    system "nc", "-z", "localhost", port
  end
end
