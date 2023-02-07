class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230206.49841bd.tar.gz"
  version "20230206"
  sha256 "95fa6fb6711d4ddac494f957ad528efe1ed0734b9fb09bc56b98394c797124c7"
  license "MIT"
  head "https://git.tartarus.org/simon/puzzles.git", branch: "main"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8})(?:\.[a-z0-9]+)?/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cbbd441458449e12df16bca530e596d01239fac00ce3cce77273e8eba3d8def"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81ac25294e945133833b651fcb5ed86d1e7b87ced2047f6ed2f73736f9789bce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "479d617a84c6c4ec882b3d3f1cfc3345b1df863b6501fcfdcda296427b025b07"
    sha256 cellar: :any_skip_relocation, ventura:        "e06ecab06afb159f0dca37d2ba0a3926aa501fe412786681a32b7b3e90f8accb"
    sha256 cellar: :any_skip_relocation, monterey:       "1718d5be1e6cb7f69cfdbec5f681bb7b51076dc33c4a6f5ff669a1e70c939999"
    sha256 cellar: :any_skip_relocation, big_sur:        "c322f5e42b7bdb24237b3ebd4bf8a23b2129b18c07a278a7f4e772be55d47e56"
    sha256                               x86_64_linux:   "a219be25808cc773239a47f2f06f6ad829c7b4f42d73ee6e5041bd0b87f62db6"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build

  on_linux do
    depends_on "imagemagick" => :build
    depends_on "pkg-config" => :build
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "pango"
  end

  conflicts_with "samba", because: "both install `net` binaries"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    bin.write_exec_script prefix/"Puzzles.app/Contents/MacOS/Puzzles" if OS.mac?
  end

  test do
    if OS.mac?
      assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
    else
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]

      assert_match "Mines, from Simon Tatham's Portable Puzzle Collection", shell_output(bin/"mines")
    end
  end
end
