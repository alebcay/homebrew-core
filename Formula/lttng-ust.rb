class LttngUst < Formula
  desc "Linux Trace Toolkit Next Generation Userspace Tracer"
  homepage "https://lttng.org/"
  url "https://lttng.org/files/lttng-ust/lttng-ust-2.13.0.tar.bz2"
  sha256 "54e4c933679cf6a07971dc5861ce57fc4876ab740ab612407b30b5fc85371750"
  license all_of: ["LGPL-2.1-only", "MIT", "GPL-2.0-only", "BSD-3-Clause", "BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2a1aaa6c23382092d5f4e8422dd1db1330b46a80631c63bb4f3441d04dc30244"
  end

  depends_on "pkg-config" => :build
  depends_on :linux
  depends_on "numactl"
  depends_on "userspace-rcu"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    cp_r (share/"doc/lttng-ust/examples/demo").children, testpath
    system "make"
    system "./demo"
  end
end
