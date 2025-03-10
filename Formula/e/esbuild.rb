class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "5e84e44d7d2c2751f0b67e8cf909def3b0189b8e9549bcd663cadab582ab2947"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3889863289a4ad37e96d025ad6d77732a8f88f7996eb57991c36e4429bcb9fb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3889863289a4ad37e96d025ad6d77732a8f88f7996eb57991c36e4429bcb9fb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3889863289a4ad37e96d025ad6d77732a8f88f7996eb57991c36e4429bcb9fb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb2354ff2ec8faffe2a6438d84111336e05bd0f8d5dfd93df4a0ddf1d2b70490"
    sha256 cellar: :any_skip_relocation, ventura:       "bb2354ff2ec8faffe2a6438d84111336e05bd0f8d5dfd93df4a0ddf1d2b70490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85b32bee603f83aa3496487f3e5d27ff9b034d6ab61058d031fe037e162bc9b6"
  end

  depends_on "go" => :build
  depends_on "node" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/esbuild"
  end

  test do
    (testpath/"app.jsx").write <<~JS
      import * as React from 'react'
      import * as Server from 'react-dom/server'

      let Greet = () => <h1>Hello, world!</h1>
      console.log(Server.renderToString(<Greet />))
      process.exit()
    JS

    system Formula["node"].libexec/"bin/npm", "install", "react", "react-dom"
    system bin/"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1>Hello, world!</h1>\n", shell_output("node out.js")
  end
end
