class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.3.2.tar.gz"
  sha256 "ee69f8c256fed8d0e692a35a5b206e24b04a00f7d82e8d9a645c28cf7d9b3b20"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e38e6f43851743efa2d25d1ffab71f7312385825ecfd8b29b1edfa14853427dd" => :big_sur
    sha256 "32a9fed5222519754a3302d0a7b48e5598cd5408cec55d0357ed4c9ba9902c56" => :catalina
    sha256 "51e5cb6791fc75534d3cc31aff5d2826955d646dac379c88d161f3da6675d4bf" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "failed to fetch root page: lookup does.not.exist: no such host",
        shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1)

    system bin/"muffet", "https://httpbin.org/"
  end
end
