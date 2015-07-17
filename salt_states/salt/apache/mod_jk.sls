{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
 - apache

decompress_modjk:
  archive:
    - order: 1
    - extracted
    - name: /usr/src/
    - source: salt://apache/files/source/mod_jk.tar.gz
    - archive_format: tar
    - if_missing: /usr/src/mod_jk
    - source_hash: md5=297add5f2643329b04f62a16578c0cab

mod_jk_deps:
  pkg.installed:
    - names:
      - apr-util-devel
      - httpd-devel
      - autoconf
      - libtool
      - mod_ssl

mod_jk_install:
  cmd.run:
    - order: 1
    - cwd: /usr/src/mod_jk/native
    - name: /usr/src/mod_jk/native/buildconf.sh && /usr/src/mod_jk/native/configure --with-apxs=/usr/bin/apxs && make && make install
    - onlyif: test ! -e /usr/lib64/httpd/modules/mod_jk.so
    - require:
      - pkg: mod_jk_deps
