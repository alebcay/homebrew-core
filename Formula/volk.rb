class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://github.com/gnuradio/volk/releases/download/v2.5.1/volk-2.5.1.tar.gz"
  sha256 "8f7f2f8918c6ba63ebe8375fe87add347046b8b3acbba2fb582577bebd8852df"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_monterey: "cd08be9bd078c3132652c270cfd6af087adc72855e36f2919e049d39fc22ba3a"
    sha256 arm64_big_sur:  "e7e77a6f19eaf1443460933a1937794300c76b00bc64fca7b0ebf9535e771f5e"
    sha256 monterey:       "0c8208cf15c8b3013fa8f1901fc06c0612458991a10e15db6f50744259e82e8e"
    sha256 big_sur:        "e5edefdbf14fdba429f56369c8c4b10f5fb7be7f5f3cd09a84d4542d0cd181a2"
    sha256 catalina:       "568e33a05f0a5efc390fd7181f1876bab39ca96abbbd9d9aca46027f61c540e8"
    sha256 x86_64_linux:   "985a55137a6942852d81447f577458d174979718475d60fc0e0cd9d2f4167fc5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cpu_features" if Hardware::CPU.intel?
  depends_on "orc"
  depends_on "python@3.10"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # https://github.com/gnuradio/volk/issues/375

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/50/ec/1d687348f0954bda388bfd1330c158ba8d7dea4044fc160e74e080babdb9/Mako-1.2.0.tar.gz"
    sha256 "9a7c7e922b87db3686210cf49d5d767033a41d4010b284e747682c92bddd8b39"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  def install
    # Set up Mako
    venv_root = libexec/"venv"
    ENV.prepend_create_path "PYTHONPATH", venv_root/Language::Python.site_packages("python3")
    venv = virtualenv_create(venv_root, "python3")
    venv.pip_install resources

    # Avoid references to the Homebrew shims directory
    inreplace "lib/CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    # cpu_features fails to build on ARM macOS.
    args = %W[
      -DPYTHON_EXECUTABLE=#{venv_root}/bin/python
      -DENABLE_TESTING=OFF
      -DVOLK_CPU_FEATURES=#{Hardware::CPU.intel?}
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Set up volk_modtool paths
    site_packages = prefix/Language::Python.site_packages("python3")
    pth_contents = "import site; site.addsitedir('#{site_packages}')\n"
    (venv_root/Language::Python.site_packages("python3")/"homebrew-volk.pth").write pth_contents
  end

  test do
    system "volk_modtool", "--help"
    system "volk_profile", "--iter", "10"
  end
end
