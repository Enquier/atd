{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

include:
 - utils

swftools_deps:
  pkg.installed:
    - order: 1
    - names:
      - gcc-c++
      - zlib-devel
      - libjpeg-turbo-devel
      - giflib-devel
      - freetype-devel 

decompress_swftools:
    archive:
    - order: 1
    - extracted
    - name: /usr/src/
    - source: salt://utils/files/source/swftools-0.9.2.tar.gz
    - archive_format: tar
    - if_missing: /usr/src/swftools-0.9.2
    - source_hash: md5=3f5107aa676c26f7b86b3af6080a2d03

fix_swf_compile1:
   file.managed:
    - name: /usr/src/swftools-0.9.2/swfs/Makefile.in
    - source: salt://utils/files/source/Makefile_fixed.in
    - onlyif: test ! -e /usr/local/bin/pdf2swf


swftools_install:
  cmd.run:
    - cwd: /usr/src/swftools-0.9.2
    - name: ./configure; cd ./lib/pdf; make; make install;cd /usr/src/swftools-0.9.2; ./configure && make && make install
    - onlyif: test ! -e /usr/local/bin/pdf2swf
    - require:
      - pkg: swftools_deps
      - file: fix_swf_compile1
