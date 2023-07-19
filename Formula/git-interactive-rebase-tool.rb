class GitInteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/2.3.0.tar.gz"
  sha256 "4af63703b3504370ef298693abc5061fe5bf215536e6d45952afda33a92f8101"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "81c3010ced34175a71c93debfca1a074559ede8dbc44c3e8503fd06bfc1e9b65"
    sha256 cellar: :any,                 arm64_monterey: "ab88da6750263baa5f17e8ef0fbf5202a72adc1f849fa90d16086d6dbf0deca9"
    sha256 cellar: :any,                 arm64_big_sur:  "cc6a74874c27c762e677cf4f882479b5392d6625b6a5286d9d81b8944af00e7b"
    sha256 cellar: :any,                 ventura:        "631910ee464118d7db43a58b6e1e0e592522feaeaaaa000fdd7f2801858581f8"
    sha256 cellar: :any,                 monterey:       "1bc6945ffa674db04d40f46768de0cd7eef18e10fbacc7a781d14f17e1cd54f4"
    sha256 cellar: :any,                 big_sur:        "8b46968eea1f837abae46382b005829cc5fd97195c6a44c64b48573e71f958d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d24e90c4a92b407827923f32162381fe6a7ce85cacdfa779429d3bedc5839320"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    mkdir testpath/"repo" do
      system "git", "init"
    end

    (testpath/"repo/.git/rebase-merge/git-rebase-todo").write <<~EOS
      noop
    EOS

    expected_git_rebase_todo = <<~EOS
      noop
    EOS

    env = { "GIT_DIR" => testpath/"repo/.git/" }
    executable = bin/"interactive-rebase-tool"
    todo_file = testpath/"repo/.git/rebase-merge/git-rebase-todo"

    _, _, pid = PTY.spawn(env, executable, todo_file)
    Process.wait(pid)

    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_equal expected_git_rebase_todo, todo_file.read
  end
end
