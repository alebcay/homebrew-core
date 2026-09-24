class Libkrunfw < Formula
  include Language::Python::Virtualenv

  desc "Dynamic library bundling the guest payload consumed by libkrun"
  homepage "https://github.com/libkrun/libkrunfw"
  url "https://github.com/libkrun/libkrunfw/archive/refs/tags/v5.6.1.tar.gz"
  sha256 "b8ec9f2205f1092a5fcd8ab8ecb8e1a939dea15bb842d844da99c5a062e3f453"
  license "LGPL-2.1-only"

  depends_on "python@3.14" => :build

  on_macos do
    resource "homebrew-case-sensitive-fs-sparseimage" do
      url "https://github.com/alebcay/build-workspace-images/raw/967f1874c35cf54619dcc38da345bed7877cdefc/100g-apfs-cs.sparseimage"
      sha256 "6a7c392df90183c604387b7d0d9ff7ff877c3aa24139ed7532f561fb8a71a16d"
    end

    patch do
      url "https://github.com/caxu-rh/libkrunfw/commit/8d540f346e952a521bec0fa1fa1439ee65d9fea2.patch?full_index=1"
      sha256 "0d340de99e6fe13e40926bcda6e301934ae0deca47b9e2d3a3c9b57c268d7f95"
      type :backport
    end
  end

  resource "kernel-source" do
    url "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.12.109.tar.xz", using: :nounzip
    sha256 "5484e552a334e15019f4aeba89e5b58f04651cf2f4e24e04de9f152f1c38e3fa"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/a3/11/767522582afab1b884d277de0e6e011640cb9d7292a38694b4b1a1df1ae8/pyelftools-0.33.tar.gz"
    sha256 "660d82dcbeb8e83d1702bd97f223f761625da06111c0cc988eac6b8ab0c1b61f"
  end

  def install
    if OS.mac?
      (buildpath.parent/"img").install resource("homebrew-case-sensitive-fs-sparseimage")
      system "hdiutil", "attach", "-mountpoint", buildpath.parent/"mnt",
buildpath.parent/"img/100g-apfs-cs.sparseimage"
      (buildpath.parent/"mnt").install buildpath.children
      cd buildpath.parent/"mnt"
    end

    kernel_version = resource("kernel-source").version.to_s
    mkdir "tarballs"
    resource("kernel-source").stage "tarballs"
    system "make", "linux-#{kernel_version}"

    kernel_binary = if Hardware::CPU.arm64?
      "linux-#{kernel_version}/arch/arm64/boot/Image"
    else
      "linux-#{kernel_version}/vmlinux"
    end

    inreplace "linux-#{kernel_version}/crypto/jitterentropy.c", "#error \"The CPU Jitter", "#warning \"The CPU Jitter"
    system "make", kernel_binary

    inreplace "linux-#{kernel_version}/crypto/jitterentropy.c", "#warning \"The CPU Jitter", "#error \"The CPU Jitter"
    rm "linux-#{kernel_version}/crypto/jitterentropy.o"
    ENV.O0 { system "make", "-C", "linux-#{kernel_version}", "crypto/jitterentropy.o" }

    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resource("pyelftools")
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    make_install_args = ["PREFIX=#{prefix}"]

    # On Linux, install to lib instead of lib64
    make_install_args << "LIBDIR_Linux=lib" if OS.linux?

    system "make"
    system "make", "install", *make_install_args
  end

  test do
    (testpath/"test_krunfw.c").write <<~C
      #include <stddef.h>

      extern char *krunfw_get_kernel(size_t *load_addr, size_t *entry_addr, size_t *size);

      int main(void) {
        size_t load_addr;
        size_t entry_addr;
        size_t size;
        char *kernel = krunfw_get_kernel(&load_addr, &entry_addr, &size);

        return kernel == NULL || size == 0 || load_addr == 0 || entry_addr == 0;
      }
    C
    system ENV.cc, "test_krunfw.c", "-L#{lib}", "-lkrunfw", "-o", "test_krunfw"
    system "./test_krunfw"
  end
end
