class FlexiblasBlis < Formula
  desc "BLIS runtime backend for FlexiBLAS"
  homepage "https://www.mpi-magdeburg.mpg.de/projects/flexiblas"
  url "https://csc.mpi-magdeburg.mpg.de/mpcsc/software/flexiblas/flexiblas-3.4.4.tar.xz"
  sha256 "f3b4db7175f00434b1ad1464c0fd004f9b9ddf4ef8d78de5a75382a1f73a75dd"
  license all_of: [
    "LGPL-3.0-or-later",
    "LGPL-2.1-or-later", # libcscutils/
  ]
  head "https://gitlab.mpi-magdeburg.mpg.de/software/flexiblas-release.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "blis"
  depends_on "flexiblas"
  depends_on "gcc" # for gfortran

  on_macos do
    depends_on "libomp" => :build
  end

  fails_with :gcc do
    version "11"
    cause "Need to build with same GCC as GFortran for LTO"
  end

  def install
    # Remove -flat_namespace usage
    inreplace "src/fallback_blas/CMakeLists.txt", " -flat_namespace\"", '"'

    # Add HOMEBREW_PREFIX path to default searchpath to allow detecting separate formulae
    inreplace "CMakeLists.txt",
              %r{(FLEXIBLAS_DEFAULT_LIB_PATH "\${CMAKE_INSTALL_FULL_LIBDIR}/\${flexiblasname}/)"},
              "\\1:#{HOMEBREW_PREFIX}/lib/${flexiblasname}\""

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DSYSCONFDIR=#{etc}
      -DEXAMPLES=OFF
      -DTESTS=OFF
      -DATLAS=OFF
      -DMklSerial=OFF
      -DMklOpenMP=OFF
      -DMklTBB=OFF
      -DOpenBLASSerial=OFF
      -DOpenBLASPthread=OFF
      -DOpenBLASOpenMP=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"

    (lib/"flexiblas").install Dir["build/lib/libflexiblas_blis*.dylib"]
    (prefix/"etc/flexiblasrc.d").install Dir["build/flexiblasrc.d/Blis*.conf"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <math.h>

      #include <cblas.h>
      #include <flexiblas_api.h>

      int main(void) {
        printf("Current loaded backend: ");
        flexiblas_print_current_backend(stdout);

        int i;
        double A[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double B[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double C[9] = {.5, .5, .5, .5, .5, .5, .5, .5, .5};
        cblas_dgemm(CblasColMajor, CblasNoTrans, CblasTrans,
                    3, 3, 2, 1, A, 3, B, 3, 2, C, 3);
        for (i = 0; i < 9; i++)
          printf("%lf ", C[i]);
        printf("\\n");
        if (fabs(C[0]-11) > 1.e-5) abort();
        if (fabs(C[4]-21) > 1.e-5) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["flexiblas"].include}/flexiblas", "-L#{Formula["flexiblas"].lib}",
           "-lflexiblas", "-o", "test"

    backends = Dir[prefix/"etc/flexiblasrc.d/*"].map { |f| File.basename(f, ".conf").upcase }
    backends.each do |backend|
      expected = <<~EOS
        Current loaded backend: #{backend}
        11.000000 -9.000000 5.000000 -9.000000 21.000000 -1.000000 5.000000 -1.000000 3.000000
      EOS
      with_env(FLEXIBLAS: backend) do
        assert_equal expected.strip, shell_output("./test").strip
      end
    end
  end
end
