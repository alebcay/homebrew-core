class Sshpass < Formula
  desc "Non-interactive SSH authentication utility"
  homepage "https://sourceforge.net/projects/sshpass/"
  url "https://downloads.sourceforge.net/project/sshpass/sshpass/1.10/sshpass-1.10.tar.gz"
  sha256 "ad1106c203cbb56185ca3bad8c6ccafca3b4064696194da879f81c8d7bdfeeda"
  license "GPL-2.0-or-later"

  uses_from_macos "expect" => :test

  def install
    system "./configure",
           *std_configure_args.reject { |s| s["--disable-debug"] },
           "--disable-silent-rules"
    system "make", "install"
  end

  def caveats
    <<~EOS
      sshpass reads credentials from plaintext files or environment variables,
      which may be accessed by other users or processes on your machine.

      See `man sshpass` for more security considerations when using sshpass.
    EOS
  end

  test do
    (testpath/"test-script").write <<~EOS
      spawn #{bin}/sshpass -P foo -v true
      expect 'SSHPASS: searching for password prompt using match \\"foo\\"'
    EOS

    system "expect", "-f", testpath/"test-script"
  end
end
