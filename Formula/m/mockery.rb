class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "010a0c884a93d355f421a0135b2f2c46a0acfed8433ac1dc631aa4d8390c6f3f"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "v3"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b00f99963857bffb96810dc19c42f85debf14a4d65a139f2793bdafbc428fcc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b00f99963857bffb96810dc19c42f85debf14a4d65a139f2793bdafbc428fcc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b00f99963857bffb96810dc19c42f85debf14a4d65a139f2793bdafbc428fcc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bfa05de4d1bfb98e625036464f94c546788d2cfec744feb234013db3aa3c18a"
    sha256 cellar: :any_skip_relocation, ventura:       "6bfa05de4d1bfb98e625036464f94c546788d2cfec744feb234013db3aa3c18a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "725e8b331ae50cd5ee5b304d55ce6cf79037e030995574993a8469247a72360f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v#{version.major}/internal/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    (testpath/".mockery.yaml").write <<~YAML
      packages:
        github.com/vektra/mockery/v2/pkg:
          interfaces:
            TypesPackage:
    YAML
    output = shell_output("#{bin}/mockery 2>&1", 1)
    assert_match "Starting mockery", output
    assert_match "version=v#{version}", output
  end
end
