class Civl < Formula
  desc "Concurrency Intermediate Verification Language"
  homepage "https://vsl.cis.udel.edu/civl/"
  url "https://vsl.cis.udel.edu/lib/sw/civl/1.21/r5476/release/CIVL-1.21_5476.tgz"
  version "1.21-5476"
  sha256 "6228c7ba17ce516921975e84001b47a6260f432af44784136164654be5e7ad4e"

  livecheck do
    url "https://vsl.cis.udel.edu/lib/sw/civl/current/latest/release/"
    regex(/href=.*?CIVL[._-]v?(\d+(?:[._-]\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c6c4de30805b69e53aacb7fb0069b67f42c48983418b3d23c97b9ef7013fe715"
  end

  depends_on "openjdk"
  depends_on "z3"

  def install
    underscored_version = version.to_s.tr("-", "_")
    libexec.install "lib/civl-#{underscored_version}.jar"
    bin.write_jar_script libexec/"civl-#{underscored_version}.jar", "civl"
    pkgshare.install "doc", "emacs", "examples", "licenses"
  end

  test do
    (testpath/".sarl").write <<~EOS
      prover {
        aliases = z3;
        kind = Z3;
        version = "#{Formula["z3"].version} - 64 bit";
        path = "#{Formula["z3"].opt_bin}/z3";
        timeout = 10.0;
        showQueries = false;
        showInconclusives = false;
        showErrors = true;
      }
    EOS
    # Test with example suggested in manual.
    example = pkgshare/"examples/concurrency/locksBad.cvl"
    assert_match "The program MAY NOT be correct.",
                 shell_output("#{bin}/civl verify #{example}")
    assert_predicate testpath/"CIVLREP/locksBad_log.txt", :exist?
  end
end
