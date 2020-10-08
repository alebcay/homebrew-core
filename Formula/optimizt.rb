require "language/node"

class Optimizt < Formula
  desc "CLI image optimization tool"
  homepage "https://github.com/funbox/optimizt"
  url "https://github.com/funbox/optimizt/archive/2.0.1.tar.gz"
  sha256 "13a9f773dd5115c6856b2624d965015cd10ee39e5003e18539b55b7ea92b7ba1"
  license "MIT"
  head "https://github.com/funbox/optimizt.git"

  depends_on "jpeg"
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    cp test_fixtures("test.png"), "test.png"
    system bin/"optimizt", "--webp", "--verbose", "test.png"
    assert_predicate testpath/"test.webp", :exist?
  end
end
