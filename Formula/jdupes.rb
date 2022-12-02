class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.21.1.tar.gz"
  sha256 "22de88d1963f70c8ed4d0aa40abe05b48aaa4cc08eed6a2c6c9747010f9f4eb7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e63ef218912e5c736b033ed73a09227fff0936b4a207e7479ca8f0690cb47e61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60496d37fa731894985ede7a3ce8fc2ae58f41daa4ff4b2f8155b72263cad8aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92aa74b194b735d10012ec3ab5768eea50e4432ea13d64cfcffdf49b5e7953a6"
    sha256 cellar: :any_skip_relocation, ventura:        "e11c030b90e303415df977b80ffc8dc26c774b137a223497074cd658d2dc41bd"
    sha256 cellar: :any_skip_relocation, monterey:       "dac797d9b5d739d9dfc17676678d623099277e94912b6f92a3aeb479a6c2e121"
    sha256 cellar: :any_skip_relocation, big_sur:        "5784038ce9ccd2fdd6663529fe60b0724c83e7f9e8e9f8d7f58f9f3bdec9d2bb"
    sha256 cellar: :any_skip_relocation, catalina:       "333bb2646c70e0960f8e857087c0bceb3bcf4a29a869e6e79b6622416e194bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "441cd0c6aa8cc17c0b040af1af3e198de4c2f35d6aa933f28f01ad56d914bc16"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ENABLE_DEDUPE=1"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
