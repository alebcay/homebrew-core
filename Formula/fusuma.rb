require "language/node"

class Fusuma < Formula
  desc "Markdown-based slide presentation tool"
  homepage "https://hiroppy.github.io/fusuma/"
  url "https://registry.npmjs.org/fusuma/-/fusuma-2.4.0.tgz"
  sha256 "58245a8254319de699c3af070d22e4e1412657ea6407163f48067d54d1b97297"
  license "MIT"

  depends_on "node"

  resource "task-pdf" do
    url "https://registry.npmjs.org/@fusuma/task-pdf/-/task-pdf-2.4.0.tgz"
    sha256 "29fbc03a89c6b0f758e66c7297845e345f3978cf8cad53f9e764998bcd5b3b1c"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    resource("task-pdf").stage do
      system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    end

    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"fusuma", "init"
    assert_predicate testpath/"style.css", :exist?
    system bin/"fusuma", "build"
    assert_predicate testpath/"dist/index.html", :exist?
    system bin/"fusuma", "pdf"
    assert_predicate testpath/"slide.pdf", :exist?
  end
end
