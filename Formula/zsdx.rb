class Zsdx < Formula
  desc "Zelda Mystery of Solarus DX"
  homepage "https://www.solarus-games.org/en/games/the-legend-of-zelda-mystery-of-solarus-dx"
  url "https://gitlab.com/solarus-games/zsdx/-/archive/v1.12.1/zsdx-v1.12.1.tar.bz2"
  sha256 "5d336c83eab2dfcef77526f4b54d6e0846dc3e2d5a952dc62d8f9540de79a0cd"
  head "https://gitlab.com/solarus-games/zsdx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f56d0855f0eb483fb531c92aa2b65a1c758f8c226196cdbef156ddc483345c1c" => :mojave
    sha256 "110c4a1ba313aacf61fff839015374cfbee29e88e23b539152827027251ace1c" => :high_sierra
    sha256 "00694b0873789ff7a904e2409dd2f87e57d37798823bdad986dd8007c0adf036" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "solarus"

  def install
    system "cmake", ".", *std_cmake_args, "-DSOLARUS_INSTALL_DATADIR=#{share}"
    system "make", "install"
  end

  test do
    system Formula["solarus"].bin/"solarus-run", "-help"
    system "/usr/bin/unzip", pkgshare/"data.solarus"
  end
end
