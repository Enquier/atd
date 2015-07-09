{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
install_fastyum_deps:
  pkg.installed:
    - names: 
       - yum-plugin-fastestmirror
       - yum-presto

/tmp/axel-2.4-1.el6.rf.x86_64.rpm:
  file.managed:
    - source: salt://utils/files/axel-2.4-1.el6.rf.x86_64.rpm

install_axel:
  cmd.run:
    - cwd: /tmp
    - name: rpm -Uvh /tmp/axel-2.4-1.el6.rf.x86_64.rpm
    - onlyif: test ! -e /usr/bin/axel

decompres_axel:
    archive:
    - extracted
    - name: /usr/src/
    - source: salt://utils/files/yum-axelget-1.0.5.1.tar.gz
    - archive_format: tar
    - if_missing: /usr/src/yum-axelget-1.0.5.1
    - source_hash: md5=c0e5c89cc72f451c6aa48d72a6667724
 
install_axelget:
  cmd.run:
    - cwd: /usr/src/yum-axelget-1.0.5.1
    - name: python /usr/src/yum-axelget-1.0.5.1/setup.py install
    - onlyif: test ! -e /etc/yum/pluginconf.d/axelget.conf
