
set_xattr_on_fs:
  cmd.run:
  - order: 1
  - name: tune2fs -o user_xattr /dev/xvde1



install_cachefilesd:
  pkg:
   - installed
   -  name: cachefilesd
  service:
   - name: cachefilesd
   - running
   - enable: True
   - reload: True
  watch:
   - file: /etc/cachefilesd.conf

/etc/cachefilesd.conf:
  file.managed:
    - source: salt://mounted_dirs/files/cachefilesd.conf.default
    - template: jinja 

/dev/cachefiles:
  file.managed:
  - order: 1
  - user: root
  - group: root
  - source: salt://mounted_dirs/files/cachefiles.default

/var/cache/fscache/graveyard:
  file.directory:
  - order: 1
  - user: root
  - group: root
  - makedirs: True
