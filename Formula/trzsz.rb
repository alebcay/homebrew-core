class Trzsz < Formula
  include Language::Python::Virtualenv

  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://files.pythonhosted.org/packages/60/fb/fcaeef46e58afa2cf2fef5ce1ad9f4e083feb157b4e12b3687114d2a5ed7/trzsz-1.1.1.tar.gz"
  sha256 "f113783ca8533252813d355e9a200e78762cafd4197a841f6b5289112ebf5805"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f2338f18c26ef9115ad67c2338b8cd07139113e89e2a40e0eaa7b696de2b8cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07154f877574bbf3fee21b8e6a13358473b3bd0d0d45130924042a004a1dbd53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c64bd93a5b3d27d0906f0e72b0c24ab4b9376da99bd744102ee5e865523b490"
    sha256 cellar: :any_skip_relocation, ventura:        "c30c763f211f69dd8163016f9f6532ad6cafab23e6576edd47a9728a659f17dd"
    sha256 cellar: :any_skip_relocation, monterey:       "f398dfd1819a386aba368ae0b3d9d2f8faf05a2f5534a75463588b6226106432"
    sha256 cellar: :any_skip_relocation, big_sur:        "544b91290504a9dd32eb95cd8088286fd47bbcb04cfd8ed87b2b78b73d265356"
    sha256 cellar: :any_skip_relocation, catalina:       "afc42b34487bfced6811239e7e0ba531a61b3d6a7f3871148f2216c60853f3b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34ec912a61b25e0d9b45afa6c72af31ef3d987f9479ab134ab483314f5157549"
  end

  depends_on "protobuf"
  depends_on "python@3.11"

  resource "iterm2" do
    url "https://files.pythonhosted.org/packages/4f/eb/47bb125fd3b32969f3bc8e0b8997bbe308484ac4d04331ae1e6199ae2c0f/iterm2-2.7.tar.gz"
    sha256 "f6f0bec46c32cecaf7be7fd82296ec4697d4bf2101f0c4aab24cc123991fa230"
  end

  resource "trzsz-iterm2" do
    url "https://files.pythonhosted.org/packages/77/5f/6b9f043c19458246886810a6af4d1f977328b2d158fa1e3825666c298498/trzsz-iterm2-1.1.1.tar.gz"
    sha256 "6bbcc011ed1936ee1ed01b33ac8f290ed90fdff2d9e0e8a6070cd61fc8e2b9bd"
  end

  resource "trzsz-libs" do
    url "https://files.pythonhosted.org/packages/01/4b/9f4ca38ba1cef8a4d44ac7115cea8eaf1e47dc88ddb10a72646682b8cc09/trzsz-libs-1.1.1.tar.gz"
    sha256 "8536733f42eb30bdede15ff49995d241447c8f64cda85d3a1a382b9267b79113"
  end

  resource "trzsz-svr" do
    url "https://files.pythonhosted.org/packages/bb/60/48cf879ebdc262769ccfd50c7954a533628c83faeae095be7dcc20f18769/trzsz-svr-1.1.1.tar.gz"
    sha256 "e02e8240b0b9de7c8c72557597954158a5591660a291b6f70a0f54e1dedcd273"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/85/dc/549a807a53c13fd4a8dac286f117a7a71260defea9ec0c05d6027f2ae273/websockets-10.4.tar.gz"
    sha256 "eef610b23933c54d5d921c92578ae5f89813438fded840c2e9809d378dc765d3"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/trz"
    bin.install_symlink libexec/"bin/tsz"
    bin.install_symlink libexec/"bin/trzsz-iterm2"
  end

  test do
    assert_match "trz (trzsz) py #{version}", shell_output("#{bin}/trz -v")
    assert_match "tsz (trzsz) py #{version}", shell_output("#{bin}/tsz -v")
    assert_match "trzsz-iterm2 (trzsz) py #{version}", shell_output("#{bin}/trzsz-iterm2 -v")

    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1")

    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1")

    assert_match "arguments are required", shell_output("#{bin}/trzsz-iterm2 2>&1", 2)
  end
end
