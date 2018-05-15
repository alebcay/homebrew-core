class Density < Formula
  desc "Superfast compression library"
  homepage "https://groups.google.com/d/forum/centaurean-density"
  url "https://github.com/centaurean/density/archive/density-0.14.2.tar.gz"
  sha256 "0b130ea9da3ddaad78810a621a758b47c4135d91d5b5fd22d60bbaf04bc147da"

  resource "cputime" do
    url "https://github.com/centaurean/cputime.git",
      :revision => "d435d91b872a4824fb507a02d0d1814ed3e791b0"
  end

  resource "spookyhash" do
    url "https://github.com/centaurean/spookyhash.git",
      :revision => "2c27b434d097198cab2272d4160b413a5f139049"
  end

  def install
    (buildpath/"benchmark/libs/cputime").install resource("cputime")
    (buildpath/"benchmark/libs/spookyhash").install resource("spookyhash")
    system "make"
    include.install "src/density_api.h"
    share.install "build/benchmark"
    lib.install "build/libdensity.a"
    lib.install "build/libdensity.dylib"
  end

  test do
    system share/"benchmark", "-f"
  end
end
