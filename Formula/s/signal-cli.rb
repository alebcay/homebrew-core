class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.13.16.tar.gz"
  sha256 "e95713d193d6641afa89bdf563f0474290d7c303b1efce1eb18eb47393476486"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94c0f7224c501f5bd3d90c250f22805674b67e4616e921048c9cd38774129089"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ed2e6d6911af53eeb52eeb0be084b98bb56be52ee78187e4c619be10a54976a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08568dce336f06b657c0aeb65cdbc985044fa43ac3cb49f8c741f4c726419584"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e9c2dd77659b66ac94a9a43cea827b9b80d40a995abaa921f61fc717bb14038"
    sha256 cellar: :any_skip_relocation, ventura:       "9a3ff50c00bbe03a757eda04f2d7609b69ca05e99a150ec953055086ebc556fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbe8302507efe35c4fd40ff369b5bcf5ca357c19d28165f3350f71d5f7e3ffd8"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  depends_on "openjdk@21"

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  on_linux do
    depends_on arch: :x86_64 # `:libsignal-cli:test` failure, https://github.com/AsamK/signal-cli/issues/1787
  end

  # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#determine-the-required-libsignal-client-version
  # To check the version of `libsignal-client`, run:
  # url=https://github.com/AsamK/signal-cli/releases/download/v$version/signal-cli-$version.tar.gz
  # curl -fsSL $url | tar -tz | grep libsignal-client
  resource "libsignal-client" do
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.73.2.tar.gz"
    sha256 "22c3ff39e07bf913f2ae3f49a75b56ed6d36576d394b9d44ef837e05e052b3e0"
  end

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", "build"
    system "gradle", "installDist"
    libexec.install (buildpath/"build/install/signal-cli").children
    (libexec/"bin/signal-cli.bat").unlink
    (bin/"signal-cli").write_env_script libexec/"bin/signal-cli", Language::Java.overridable_java_home_env("21")

    resource("libsignal-client").stage do |r|
      # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#manual-build

      libsignal_client_jar = libexec.glob("lib/libsignal-client-*.jar").first
      embedded_jar_version = Version.new(libsignal_client_jar.to_s[/libsignal-client-(.*)\.jar$/, 1])
      res = r.resource
      odie "#{res.name} needs to be updated to #{embedded_jar_version}!" if embedded_jar_version != res.version

      # rm originally-embedded libsignal_jni lib
      system "zip", "-d", libsignal_client_jar, "libsignal_jni_*.so", "libsignal_jni_*.dylib", "signal_jni_*.dll"

      # build & embed library for current platform
      cd "java" do
        inreplace "settings.gradle", "include ':android'", ""
        system "./build_jni.sh", "desktop"
        cd "client/src/main/resources" do
          arch = Hardware::CPU.intel? ? "amd64" : "aarch64"
          system "zip", "-u", libsignal_client_jar, shared_library("libsignal_jni_#{arch}")
        end
      end
    end
  end

  test do
    # test 1: checks class loading is working and version is correct
    output = shell_output("#{bin}/signal-cli --version")
    assert_match "signal-cli #{version}", output

    # test 2: ensure crypto is working
    begin
      io = IO.popen("#{bin}/signal-cli link", err: [:child, :out])
      sleep 24
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end
    assert_match "sgnl://linkdevice?uuid=", io.read
  end
end
