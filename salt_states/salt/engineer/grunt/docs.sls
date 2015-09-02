/home/centos/git:
  file.directory:
    - user: centos
    - group: wheel
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode  

update_repo:
  git.latest:
    - target: /home/centos/git
    - user: centos
    - group: wheel
    - name: git@github.com:nomagic-com/MBEE-Webapp.git

"npm install && grunt ngdocs":
  cmd.run:
    - cwd: /home/centos/git/MBEE-Webapp
    - user: centos
    - group: wheel