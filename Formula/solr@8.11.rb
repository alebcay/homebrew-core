class SolrAT811 < Formula
  desc "Enterprise search platform from the Apache Lucene project"
  homepage "https://solr.apache.org/"
  url "https://dlcdn.apache.org/lucene/solr/8.11.2/solr-8.11.2.tgz"
  mirror "https://archive.apache.org/dist/lucene/solr/8.11.2/solr-8.11.2.tgz"
  sha256 "54d6ebd392942f0798a60d50a910e26794b2c344ee97c2d9b50e678a7066d3a6"
  license "Apache-2.0"

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    pkgshare.install "bin/solr.in.sh"
    pkgetc.install "server/solr/README.txt", "server/solr/solr.xml", "server/solr/zoo.cfg"
    (var/"lib").install_symlink pkgetc => "solr@8.11"
    prefix.install %w[contrib dist server]
    libexec.install "bin"
    bin.install [libexec/"bin/solr", libexec/"bin/post", libexec/"bin/oom_solr.sh"]

    env = Language::Java.overridable_java_home_env
    env["SOLR_HOME"] = "${SOLR_HOME:-#{var/"lib/solr@8.11"}}"
    env["SOLR_LOGS_DIR"] = "${SOLR_LOGS_DIR:-#{var/"log/solr@8.11"}}"
    env["SOLR_PID_DIR"] = "${SOLR_PID_DIR:-#{var/"run/solr@8.11"}}"
    bin.env_script_all_files libexec, env
    (libexec/"bin").rmtree

    inreplace libexec/"solr", "/usr/local/share/solr", pkgshare
  end

  def post_install
    (var/"run/solr@8.11").mkpath
    (var/"log/solr@8.11").mkpath
  end

  service do
    run [opt_bin/"solr", "start", "-f", "-s", HOMEBREW_PREFIX/"var/lib/solr"]
    working_dir HOMEBREW_PREFIX
  end

  test do
    ENV["SOLR_PID_DIR"] = testpath
    port = free_port

    # Info detects no Solr node => exit code 3
    assert_match "No Solr nodes are running.", shell_output(bin/"solr -i", 3)

    # Start a Solr node => exit code 0
    assert_match "Started Solr server on port #{port}",
                 shell_output(bin/"solr start -p #{port} -Djava.io.tmpdir=/tmp")

    # Info detects a Solr node => exit code 0
    assert_match "Found 1 Solr nodes:", shell_output(bin/"solr -i")

    # Impossible to start a second Solr node on the same port => exit code 1
    assert_match "Port #{port} is already being used by another process",
                 shell_output(bin/"solr start -p #{port}", 1)

    # Stop a Solr node => exit code 0
    # Exit code is 1 in a docker container, see https://github.com/apache/solr/pull/250
    expected_exit_code = (OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]) ? 1 : 0
    assert_match "Sending stop command to Solr running on port #{port}",
                 shell_output(bin/"solr stop -p #{port}", expected_exit_code)

    # No Solr node left to stop => exit code 1
    assert_match "No process found for Solr node running on port #{port}",
                 shell_output(bin/"solr stop -p #{port}", 1)
  end
end
