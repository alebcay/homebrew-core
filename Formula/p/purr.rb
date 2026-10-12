class Purr < Formula
  desc "Versatile zsh CLI tool for viewing and searching through Android logcat output"
  homepage "https://github.com/google/purr"
  license "Apache-2.0"
  head "https://github.com/google/purr.git", branch: "main"

  stable do
    url "https://github.com/google/purr/archive/refs/tags/2.0.4.tar.gz"
    sha256 "ce8b4d31d6b56e79808f12a37795ea15127f3e01eb94f2becb1ee1cd8724844a"

    # Avoid `sed -i` usage in makefile which requires GNU sed
    patch do
      url "https://github.com/google/purr/commit/501be2d913be95eb5263ecd83c7d36aedf04af2b.patch?full_index=1"
      sha256 "50947df5a599677b749fe933f4835db99eaaa846491be182a060ce740a5027b4"
      type :backport
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8b49680bea9c23c42497fb937f830479971b2c5aa6a7d1fb4ba14b7a83da6baf"
  end

  depends_on "fzf"

  uses_from_macos "zsh"

  deny_network_access!

  def install
    system "make"
    bin.install "out/purr"

    # This is needed for test
    system "make", "adb_mock", "file_tester", "OUTDIR=#{pkgshare}"
    chmod 0755, "#{pkgshare}/adb_mock"
    chmod 0755, "#{pkgshare}/file_tester"
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purr -v")
    system pkgshare/"file_tester", "-a", pkgshare/"adb_mock", "-p", bin/"purr"
  end
end
