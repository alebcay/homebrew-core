class Cubelib < Formula
  desc "Cube, is a performance report explorer for Scalasca and Score-P"
  homepage "https://scalasca.org/scalesca/software/cube-4.x/download.html"
  url "https://apps.fz-juelich.de/scalasca/releases/cube/4.6/dist/cubelib-4.6.tar.gz"
  sha256 "36eaffa7688db8b9304c9e48ca5dc4edc2cb66538aaf48657b9b5ccd7979385b"

  livecheck do
    url :homepage
    regex(/href=.*?cubelib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "6b647d7c7673d0b4b95c7240dc477ee13e0fdd5c9f8952bd9b8d80b0f3f55d4d"
    sha256 big_sur:       "2680056fa693e78f9f89fcaa55b67888c4aa2d947cc4a2c9d2167e3380782517"
    sha256 catalina:      "5b03ba168b4d88c74b68409a9d7fc5b6aca796a78b7e55d29a1cba2d29e1595a"
    sha256 mojave:        "5eca16fc5e707d28e6595f070a49516d65a46aa495b95ab78616777027e36114"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch :DATA

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build

  def install
    ENV.deparallelize

    inreplace "build-frontend/configure.ac",
              "[AC_MSG_ERROR([No ISO C99 support in C compiler.])]",
              "AC_MSG_ERROR([No ISO C99 support in C compiler.])"

    inreplace "build-config/common/m4/ac_scorep_c99.m4" do |s|
      s.gsub! "[_AC_C_STD_TRY([c99],", "_AC_C_STD_TRY([c99],"
      s.gsub! "])# _AC_SCOREP_PROG_CC_C99", ")# _AC_SCOREP_PROG_CC_C99"
    end

    cd "build-frontend" do
      system "autoreconf", "-ivf"
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-nocross-compiler-suite=clang",
                          "CXXFLAGS=-stdlib=libc++",
                          "LDFLAGS=-stdlib=libc++",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    cp_r "#{share}/doc/cubelib/example/", testpath
    chdir "#{testpath}/example" do
      # build and run tests
      system "make", "-f", "Makefile.frontend", "all"
      system "make", "-f", "Makefile.frontend", "run"
    end
  end
end
__END__
--- a/build-frontend/configure.orig	2021-10-01 08:15:08.000000000 -0700
+++ b/build-frontend/configure		  2021-10-20 12:44:47.000000000 -0700
@@ -8733,16 +8733,11 @@
       _lt_dar_allow_undefined='$wl-undefined ${wl}suppress' ;;
     darwin1.*)
       _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-    darwin*) # darwin 5.x on
-      # if running on 10.5 or later, the deployment target defaults
-      # to the OS version, if on x86, and 10.4, the deployment
-      # target defaults to 10.4. Don't you love it?
-      case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
-	10.0,*86*-darwin8*|10.0,*-darwin[91]*)
-	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
-	10.[012][,.]*)
+    darwin*)
+      case ${MACOSX_DEPLOYMENT_TARGET},$host in
+	10.[012],*|,*powerpc*)
 	  _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-	10.*)
+	*)
 	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
       esac
     ;;
--- a/build-config/m4/libtool.m4.orig	2021-10-01 08:15:08.000000000 -0700
+++ b/build-config/m4/libtool.m4		  2021-10-20 12:44:47.000000000 -0700
@@ -1067,16 +1067,11 @@ _LT_EOF
       _lt_dar_allow_undefined='$wl-undefined ${wl}suppress' ;;
     darwin1.*)
       _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-    darwin*) # darwin 5.x on
-      # if running on 10.5 or later, the deployment target defaults
-      # to the OS version, if on x86, and 10.4, the deployment
-      # target defaults to 10.4. Don't you love it?
-      case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
-	10.0,*86*-darwin8*|10.0,*-darwin[[91]]*)
-	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
-	10.[[012]][[,.]]*)
+    darwin*)
+      case ${MACOSX_DEPLOYMENT_TARGET},$host in
+	10.[[012]],*|,*powerpc*)
 	  _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-	10.*)
+	*)
 	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
       esac
     ;;
