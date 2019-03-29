class Giflib < Formula
  desc "Library and utilities for processing GIFs"
  homepage "https://giflib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-5.1.9.tar.bz2"
  sha256 "292b10b86a87cb05f9dcbe1b6c7b99f3187a106132dd14f1ba79c90f561c3295"

  bottle do
    cellar :any
    sha256 "8b928fd9ce46279d60a9ac73f795f3e068cc1478fcae4aabc8f7231d972820ec" => :mojave
    sha256 "0c9517138125951ae8fd38f026aa970bb877f1ae7564e47863cdf64a2adebb2e" => :high_sierra
    sha256 "a298e371464c6bcbe67c5f0c8b23de398980ad3a5ac3e8507f0ee29fef0c9e13" => :sierra
    sha256 "91161dd227491e058a9ca79ca89bb647d2bac5e368bed5457fc80a30d383ff2d" => :el_capitan
  end

  patch :p0, :DATA

  def install
    inreplace "Makefile", "USOURCES = qprintf.c quantize.c getarg.c", "USOURCES = qprintf.c quantize.c getarg.c gif_err.c"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/giftext #{test_fixtures("test.gif")}")
    assert_match "Screen Size - Width = 1, Height = 1", output
  end
end

__END__
--- Makefile	2019-04-02 16:17:24.000000000 -0400
+++ Makefile	2019-04-02 16:10:23.000000000 -0400
@@ -68,13 +68,13 @@
 $(UTILS):: libgif.a libutil.a

 libgif.so: $(OBJECTS) $(HEADERS)
-	$(CC) $(CFLAGS) -shared $(LDFLAGS) -Wl,-soname -Wl,libgif.so.$(LIBMAJOR) -o libgif.so $(OBJECTS)
+	$(CC) $(CFLAGS) -dynamiclib -current_version $(LIBVER) $(OBJECTS) -o libgif.$(LIBMAJOR).dylib

 libgif.a: $(OBJECTS) $(HEADERS)
 	$(AR) rcs libgif.a $(OBJECTS)

 libutil.so: $(UOBJECTS) $(UHEADERS)
-	$(CC) $(CFLAGS) -shared $(LDFLAGS) -Wl,-soname -Wl,libutil.so.$(LIBMAJOR) -o libutil.so $(UOBJECTS)
+	$(CC) $(CFLAGS) -dynamiclib -current_version $(LIBVER) $(UOBJECTS) -o libutil.$(LIBMAJOR).dylib

 libutil.a: $(UOBJECTS) $(UHEADERS)
 	$(AR) rcs libutil.a $(UOBJECTS)
@@ -100,9 +100,8 @@
 install-lib:
 	$(INSTALL) -d "$(DESTDIR)$(LIBDIR)"
 	$(INSTALL) -m 644 libgif.a "$(DESTDIR)$(LIBDIR)/libgif.a"
-	$(INSTALL) -m 755 libgif.so "$(DESTDIR)$(LIBDIR)/libgif.so.$(LIBVER)"
-	ln -sf libgif.so.$(LIBVER) "$(DESTDIR)$(LIBDIR)/libgif.so.$(LIBMAJOR)"
-	ln -sf libgif.so.$(LIBMAJOR) "$(DESTDIR)$(LIBDIR)/libgif.so"
+	$(INSTALL) -m 755 libgif.$(LIBMAJOR).dylib "$(DESTDIR)$(LIBDIR)/libgif.$(LIBMAJOR).dylib"
+	ln -sf libgif.$(LIBMAJOR).dylib "$(DESTDIR)$(LIBDIR)/libgif.dylib"
 install-man:
 	$(INSTALL) -d "$(DESTDIR)$(MANDIR)/man1"
 	$(INSTALL) -m 644 doc/*.1 "$(DESTDIR)$(MANDIR)/man1"
