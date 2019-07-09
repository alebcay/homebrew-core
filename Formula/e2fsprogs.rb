class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.45.4/e2fsprogs-1.45.4.tar.gz"
  sha256 "e69c69839cf80cb55afa18b9a99ed8f2e559db0313e3d15ac5497ed7e1a34c4b"
  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  bottle do
    sha256 "a2b0a389e56c197c9a68c3a0598933534c6e0da0b15023dec490cbe3889d49c7" => :catalina
    sha256 "8bfa7f8116eabc2422696487b228493ddcc2991699a3158de30d6dba6c10ef73" => :mojave
    sha256 "f0850aaef4670664e086d9a30568f5a50b5da21bf27d03b8e26478d44b2436f7" => :high_sierra
    sha256 "70bfe479fd8e5769780ad9b408739653c8b4ef94d4752c9b65ebe134c2b03eb4" => :sierra
  end

  keg_only "this installs several executables which shadow macOS system commands"

  depends_on "pkg-config" => :build
  depends_on "gettext"

  def install
    # Enforce MKDIR_P to work around a configure bug
    # see https://github.com/Homebrew/homebrew-core/pull/35339
    # and https://sourceforge.net/p/e2fsprogs/discussion/7053/thread/edec6de279/
    system "./configure", "--prefix=#{prefix}", "--disable-e2initrd-helper",
                          "MKDIR_P=mkdir -p"

    system "make"
    system "make", "install"
    system "make", "install-libs"
  end

  test do
    assert_equal 36, shell_output("#{bin}/uuidgen").strip.length
    system bin/"lsattr", "-al"
  end
end
