class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_1.0.1.tar.gz"
  sha256 "86df82e1180f07bd0be19225776db8fbe199d66e715a343d8c0c3444b05ec00b"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7d53786b313a6ed4f6b4e0e8781f511f39e815b1fd52e7a6731dc4273802295c"
    sha256 cellar: :any, big_sur:       "f79e6842a397bc0da3208dfeb133784caac0d9ee14b7ba1f20f1e377fc54ea26"
    sha256 cellar: :any, catalina:      "193e7a0b38a21425d0c5a9cf72a13f9c6baafe09072056eb521ae46ffcff43ab"
    sha256 cellar: :any, mojave:        "1674a7100e0ce0823b907ca07b3c5834dc9ff9f2b57b6da5cc71d5b09a07dd51"
    sha256 cellar: :any, high_sierra:   "6ed35324d633aef69f2493c7bede7729cadadcce9c60149ee28f1326a1da8bd7"
  end

  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}", "V=1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "xlsxwriter.h"

      int main() {
          lxw_workbook  *workbook  = workbook_new("myexcel.xlsx");
          lxw_worksheet *worksheet = workbook_add_worksheet(workbook, NULL);
          int row = 0;
          int col = 0;

          worksheet_write_string(worksheet, row, col, "Hello me!", NULL);

          return workbook_close(workbook);
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxlsxwriter", "-o", "test"
    system "./test"
    assert_predicate testpath/"myexcel.xlsx", :exist?, "Failed to create xlsx file"
  end
end
