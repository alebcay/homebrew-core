class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/archive/refs/tags/2.6.0.tar.gz"
  sha256 "1e64ff30226266e4f14cbf074161c3c815e7d991c62c71ef1d2c44b0f89d85f6"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c3d3ead692d5963f807280528ccd8e78d6f37d2a3230cb4c9442a31c44c49a1b"
    sha256 cellar: :any_skip_relocation, big_sur:       "c3d3ead692d5963f807280528ccd8e78d6f37d2a3230cb4c9442a31c44c49a1b"
    sha256 cellar: :any_skip_relocation, catalina:      "c3d3ead692d5963f807280528ccd8e78d6f37d2a3230cb4c9442a31c44c49a1b"
    sha256 cellar: :any_skip_relocation, mojave:        "c3d3ead692d5963f807280528ccd8e78d6f37d2a3230cb4c9442a31c44c49a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "899d7b2dbbfba0279aed9df963356dae18c0624490a1232062e603fc3efbe435"
  end

  depends_on "bazelisk" => :build
  depends_on "cmake" => :build
  depends_on "python@3.10" => :build
  depends_on "openjdk"

  uses_from_macos "netcat" => :test

  resource "rocksdb" do
    url "https://github.com/facebook/rocksdb/archive/v6.26.1.tar.gz"
    sha256 "5aeb94677bdd4ead46eb4cefc3dbb5943141fb3ce0ba627cfd8cbabeed6475e7"
  end

  resource "zlib" do
    url "https://zlib.net/zlib-1.2.11.tar.gz", using: :nounzip
    sha256 "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"
  end

  resource "bzip2" do
    url "https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz", using: :nounzip
    sha256 "ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269"
  end

  resource "snappy" do
    url "https://github.com/google/snappy/archive/1.1.8.tar.gz", using: :nounzip
    sha256 "16b677f07832a612b0836178db7f374e414f94657c138e6993cbfc5dcc58651f"
  end

  resource "lz4" do
    url "https://github.com/lz4/lz4/archive/v1.9.3.tar.gz", using: :nounzip
    sha256 "030644df4611007ff7dc962d981f390361e6c97a34e5cbc393ddfbe019ffe2c1"
  end

  resource "zstd" do
    url "https://github.com/facebook/zstd/archive/v1.4.9.tar.gz", using: :nounzip
    sha256 "acf714d98e3db7b876e5b540cbf6dee298f60eb3c0723104f6d3f065cd60d6a8"
  end

  def install
    env_path = if OS.mac?
      "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
    else
      "#{Formula["python@3.9"].opt_libexec}/bin:#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
    end
    args = %W[
      --compilation_mode=opt
      --curses=no
      --show_task_finish
      --verbose_failures
      --action_env=PATH=#{env_path}
      --host_action_env=PATH=#{env_path}
    ]

    mkdir libexec

    if OS.mac?
      system Formula["bazelisk"].opt_bin/"bazelisk", "build", *args, "//:assemble-mac-zip"
      system "bsdtar", "-xf", "bazel-bin/typedb-all-mac.zip", "--strip-components=1", "-C", libexec
    else
      system Formula["bazelisk"].opt_bin/"bazelisk", "build", *args, "//:assemble-linux-targz"
      system "tar", "-xf", "bazel-bin/typedb-all-linux.tar.gz", "--strip-components=1", "-C", libexec
    end

    # On Apple Silicon, we need to replace the included x86_64-only RocksDB
    # JNI library with one for arm64
    if Hardware::CPU.arm? && OS.mac?
      resource("rocksdb").stage do |r|
        rocksdb_path = Pathname.pwd
        # Put dependency source tarballs where the RocksDB Makefile expects them to be,
        # so that it doesn't try to download them separately
        %w[zlib bzip2 snappy lz4 zstd].each do |dep|
          resource(dep).stage do |dep_resource|
            rocksdb_path.install Dir["*"].first => "#{dep}-#{dep_resource.version}.tar.gz"
          end
        end

        # Avoid -march=native usage
        inreplace "build_tools/build_detect_platform", "-march=native", ""

        # Build static RocksDB and JNI library (which is what TypeDB uses)
        ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
        system "make", "rocksdbjavastatic"

        # Replace the macOS JNI lib inside the JARs that TypeDB ships with freshly built one
        jar_version = r.version.to_s.tr(".", "-")
        %W[
          #{libexec}/server/lib/prod/org-rocksdb-rocksdbjni-#{jar_version}.jar
          #{libexec}/server/lib/dev/org-rocksdb-rocksdbjni-dev-mac-#{jar_version}.jar
        ].each do |jar|
          system Formula["openjdk"].opt_bin/"jar", "-uf", jar, "-C", "java/target", "librocksdbjni-osx.jnilib"
        end
      end
    end

    bin.install libexec/"typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env)
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
