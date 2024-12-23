class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.53",
      revision: "7608a703e4eacb1440e9a038c88591cdca944fa2"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aca48e14685090e347e1f370e07c9aec58b1848b50c4c43caeb7bfb4f5d0e6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7aca48e14685090e347e1f370e07c9aec58b1848b50c4c43caeb7bfb4f5d0e6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7aca48e14685090e347e1f370e07c9aec58b1848b50c4c43caeb7bfb4f5d0e6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3698de4023784c62ee55ba9fcab59cd8731430de340a85d4feeb51c3b2053acc"
    sha256 cellar: :any_skip_relocation, ventura:       "3698de4023784c62ee55ba9fcab59cd8731430de340a85d4feeb51c3b2053acc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75f7b291ea59a83fb2cf1e91ad5982a4bdc2010df9112bdc54ac52691129d46e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion", base_name: "fly")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
