class Osc < Formula
  include Language::Python::Virtualenv

  desc "The command-line interface to work with an Open Build Service"
  homepage "https://github.com/openSUSE/osc"
  url "https://github.com/openSUSE/osc/archive/0.165.4.tar.gz"
  sha256 "c5dd020dc451b482223af94f9a89f59e533f258b531ca8f9b43411d77036d36c"
  head "https://github.com/openSUSE/osc.git"

  bottle do
    cellar :any
    sha256 "421e4df99f7b0ba5d0de94997044f371373ae267ad4f9e7958f45f143bce5d4b" => :mojave
    sha256 "4f79dde31c2bc61d87f5d82b588ed7f6c02ff26cd816e4811f87c6fec764b109" => :high_sierra
    sha256 "2abd032fe1c24461b9b65a9d53f80786909d2039aec1b1ea84734fe47b47f099" => :sierra
  end

  depends_on "swig" => :build
  depends_on "openssl@1.1" # For M2Crypto
  depends_on "python"

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/ac/b3/0f3979633b7890bab6098d84c84467030b807a1e2b31f5d30103af5a71ca/pycurl-7.43.0.3.tar.gz"
    sha256 "6f08330c5cf79fa8ef68b9912b9901db7ffd34b63e225dce74db56bb21deda8e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "urlgrabber" do
    url "https://files.pythonhosted.org/packages/ad/9f/cdd1619aa18f1bcf442032cdc0878196400270abc99035d6cf98901e51a1/urlgrabber-4.0.0.tar.gz"
    sha256 "79c5a01c5dd31906a7f38ef1f500030e137704804d585644693d3e474ed15f39"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/74/18/3beedd4ac48b52d1a4d12f2a8c5cf0ae342ce974859fba838cbbc1580249/M2Crypto-0.35.2.tar.gz"
    sha256 "4c6ad45ffb88670c590233683074f2440d96aaccb05b831371869fc387cbd127"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/d9/ca/7279974e489e8b65003fe618a1a741d6350227fa2bf48d16be76c7422423/setuptools-41.2.0.zip"
    sha256 "66b86bbae7cc7ac2e867f52dc08a6bd064d938bac59dfec71b9b565dd36d6012"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/60/e8/944bd083411be12c6d46d400a06744a5a85ad27d3c6e487a5da0d58950cc/typing-3.7.4.tar.gz"
    sha256 "53765ec4f83a2b720214727e319607879fec4acde22c4fbb54fa2604e79e44ce"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/a9/8a/580c7176f01540615c2eb3f3ab5462613b4beac4aa63410be89ecc7b7472/virtualenv-16.7.2.tar.gz"
    sha256 "909fe0d3f7c9151b2df0a2cb53e55bdb7b0d61469353ff7a49fd47b0f0ab9285"
  end

  def install
    # avoid pycurl error about compile-time and link-time curl version mismatch
    ENV.delete "SDKROOT"

    ENV["SWIG_FEATURES"]="-I#{Formula["openssl@1.1"].opt_include}"

    venv = virtualenv_create(libexec)
    venv.pip_install resources.reject { |r| r.name == "M2Crypto" || r.name == "pycurl" }

    resource("M2Crypto").stage do
      inreplace "setup.py" do |s|
        s.gsub! "self.swig_opts.append('-I/usr/include/openssl')",
                "self.swig_opts.append('-I#{Formula["openssl@1.1"].include}')"
        s.gsub! "platform.system() == \"Linux\"",
                "platform.system() == \"Darwin\" or \\0"
      end
      venv.pip_install "."
    end

    # avoid error about libcurl link-time and compile-time ssl backend mismatch
    resource("pycurl").stage do
      system libexec/"bin/pip", "install",
             "--install-option=--libcurl-dll=/usr/lib/libcurl.dylib", "-v",
             "--no-binary", ":all:", "--ignore-installed", "."
    end

    inreplace "osc/conf.py", "'/etc/ssl/certs'", "'#{etc}/openssl/cert.pem'"
    venv.pip_install_and_link buildpath
    mv bin/"osc-wrapper.py", bin/"osc"
  end

  test do
    system bin/"osc", "--version"
  end
end
