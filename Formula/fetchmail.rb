class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.20.tar.xz"
  sha256 "c82141ae2e8f0039ceb0c5c2eda43c5e93ad0bf7f9c6bb628092b3be74386176"
  license all_of: [
    "LGPL-2.1-or-later",
    "ISC",
    "BSD-3-Clause",
    :public_domain,
    "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" },
  ]

  livecheck do
    url :stable
    regex(%r{url=.*?/branch_\d+(?:\.\d+)*?/fetchmail[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e97c0fc4abef77ea5917ed66a9612066ab6e2dcf4b8da79b3e196262d1a25a2f"
    sha256 cellar: :any, big_sur:       "d68cead57a80c3d8590f987b37d59d43510240c216be8d8d84320e13cb321e4d"
    sha256 cellar: :any, catalina:      "8138e5ef22459d5b60ba45cc2b7c3a052fbb4aee004788440b346e6d797b8a2f"
    sha256 cellar: :any, mojave:        "56d6a9d7396238ccf0068fac134d44e4a6bb7a7164846e2094039d2c252b4504"
    sha256               x86_64_linux:  "8892dfbb3a7d899d9449414ecf2d52b6fd9c13992dfd31f2c29ce1a3d3d4e66a"
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fetchmail", "--version"
  end
end
