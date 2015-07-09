{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

{# REPO VERSION OUT OF DATE
haproxy:
  pkg: 
   - installed
   - name: haproxy
  service:
   - name: haproxy
   - running
   - enable: True
   - reload: True
   - watch:
     - file: /etc/haproxy/haproxy.cfg
#}


/etc/ssl/ems-stg.pem:
  file.managed:
    - source: salt://haproxy/files/ems-stg.pem
    - user: root
    - group: root

decompress_haproxy_source:
  archive:
    - extracted
    - name: /usr/src
    - source: salt://haproxy/files/haproxy-1.5.2.tar.gz
    - archive_format: tar
    - if_missing: /usr/src/haproxy-1.5.2

build_haproxy_source:
  cmd.run:
    - cwd: /usr/src/haproxy-1.5.2
    - name: cd /usr/src/haproxy-1.5.2;  make TARGET=linux26 USE_OPENSSL=1 ADDLIB=-lz USE_ZLIB=yes; make PREFIX=/usr/local/haproxy install

install_alt_link:
  alternatives.install:
    - name: haproxy
    - link: /usr/sbin/haproxy
    - path: /usr/local/haproxy/sbin/haproxy
    - priority: 30

