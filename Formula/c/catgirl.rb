class Catgirl < Formula
  desc "TLS-only terminal IRC client"
  homepage "https://git.causal.agency/catgirl/"
  url "https://git.causal.agency/catgirl/snapshot/catgirl-2.2a.tar.gz"
  sha256 "c6d760aaee134e052586def7a9103543f7281fde6531fbcb41086470794297c2"
  license "GPL-3.0-or-later"
  head "https://git.causal.agency/catgirl.git", branch: "master"

  depends_on "pkg-config" => :build
  depends_on "libretls"

  uses_from_macos "ncurses"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    args << "--enable-sandman" if OS.mac?

    system "./configure", *args
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    r, w, _pid = PTY.spawn("#{bin}/catgirl -h irc.libera.chat")
    r.winsize = [24, 80]
    r.each_line do |line|
      w.puts "/quit" if line.include?("Welcome to Libera Chat")
    end
  end
end
