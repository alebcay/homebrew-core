class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.11.tar.gz"
  sha256 "c360c4de097dae1b252b89497e80269a8903e598d398d0c1b5469297eff57ca5"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b1ba4deebf753b7a87d11686940367660b51ad4577fa0d93e6b7ad73e09793f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b1ba4deebf753b7a87d11686940367660b51ad4577fa0d93e6b7ad73e09793f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b1ba4deebf753b7a87d11686940367660b51ad4577fa0d93e6b7ad73e09793f"
    sha256 cellar: :any_skip_relocation, ventura:        "b694d7e9193175af4944f096c8d6c72f7a305832f3dfeedcfabe2eaa94fca028"
    sha256 cellar: :any_skip_relocation, monterey:       "b694d7e9193175af4944f096c8d6c72f7a305832f3dfeedcfabe2eaa94fca028"
    sha256 cellar: :any_skip_relocation, big_sur:        "b694d7e9193175af4944f096c8d6c72f7a305832f3dfeedcfabe2eaa94fca028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f98f1a0e71b42b181f615484cef64bc51f976e233933d220d0f8b254b49bf834"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{version}-#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/envd version --short")
    assert_equal "envd: v#{version}", output.strip

    expected = if OS.mac?
      "error: Cannot connect to the Docker daemon"
    else
      "error: permission denied"
    end

    stderr = shell_output("#{bin}/envd env list 2>&1", 1)
    assert_match expected, stderr
  end
end
