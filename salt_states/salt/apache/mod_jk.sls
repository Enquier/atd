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
    - source: http://apache.cs.utah.edu/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.40-src.tar.gz
    - archive_format: tar
    - if_missing: /usr/src/tomcat-connectors-1.2.40-src
    - source_hash: md5=7e6f4e4dbf5261f42ddd1fdbb9ac3e32

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
    - cwd: /usr/src/tomcat-connectors-1.2.40-src/native
    - name: ./buildconf.sh && ./configure --with-apxs=/usr/bin/apxs && make && make install
    - onlyif: test ! -e /usr/lib64/httpd/modules/mod_jk.so
    - require:
      - pkg: mod_jk_deps
