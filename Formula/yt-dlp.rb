class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Video downloader forked from youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/bd/52/cf28f80b455419c63bac921c62249014667257c45e0949a6fe385fe99661/yt-dlp-2021.7.24.tar.gz"
  sha256 "d75a0a14c169bb3553ae356683acf111cc91a0c430204db96740237d42da7375"
  license "Unlicense"
  head "https://github.com/yt-dlp/yt-dlp.git"

  depends_on "python@3.9"

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/f3/d9/2232a4cb9a98e2d2501f7e58d193bc49c956ef23756d7423ba1bd87e386d/mutagen-1.45.1.tar.gz"
    sha256 "6397602efb3c2d7baebd2166ed85731ae1c1d475abca22090b7141ff5034b3e1"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/88/7f/740b99ffb8173ba9d20eb890cc05187677df90219649645aca7e44eb8ff4/pycryptodome-3.10.1.tar.gz"
    sha256 "3e2e3a06580c5f190df843cdb90ea28d61099cf4924334d5297a995de68e4673"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/0d/bd/5262054455ab2067e51de331bfbc53a1dfa9071af7c424cf7c0793c4349a/websockets-9.1.tar.gz"
    sha256 "276d2339ebf0df4f45df453923ebd2270b87900eda5dfd4a6b0cfa15f82111c3"
  end

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/yt-dlp.1" => "yt-dlp.1"
    bash_completion.install_symlink libexec/"share/bash-completion/completions/yt-dlp"
    zsh_completion.install_symlink libexec/"share/zsh/site-functions/_yt-dlp"
    fish_completion.install_symlink libexec/"share/fish/vendor_completions.d/yt-dlp.fish"
  end

  test do
    # commit history of homebrew-core repo
    system bin/"yt-dlp", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system bin/"yt-dlp", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
