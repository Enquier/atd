/home/{{ pillar['git_user'] }}/git:
  file.directory:
    - user: {{ pillar['git_user'] }}
    - group: {{ pillar['git_group'] }}
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode  

update_webapp:
  git.latest:
    - target: /home/{{ pillar['git_user'] }}/git
    - user: {{ pillar['git_user'] }}
    - group: {{ pillar['git_group'] }}
    - name: git@github.com:nomagic-com/MBEE-Webapp.git



"npm install && grunt clean && grunt && grunt ngdocs":
  cmd.run:
    - cwd: /home/{{ pillar['git_user'] }}/git/MBEE-Webapp
    - user: {{ pillar['git_user'] }}
    - group: {{ pillar['git_group'] }}
    - onchanges:
      - git: update_webapp

"rm -rf ./webapp":
  cmd.run:
    - cwd: var/www/html
    - user: root
    - group: root
    - require:
      - cmd: "npm install && grunt ngdocs"
    - onchanges:
      - git: update_webapp
    

"cp -r ./docs/ /var/www/html/webapp/ && chown -R apache:apache /var/www/ && systemctl reload httpd":
  cmd.run:
    - cwd: /home/{{ pillar['git_user'] }}/git/MBEE-Webapp
    - user: root
    - group: root
    - require:
      - cmd: "rm -rf ./webapp"
    - onchanges:
      - git: update_webapp
      
update_repo:
  git.latest:
    - target: /home/{{ pillar['git_user'] }}/git
    - user: {{ pillar['git_user'] }}
    - group: {{ pillar['git_group'] }}
    - name: git@github.com:nomagic-com/MBEE-Repo.git
        
"rm -rf ./repo":
  cmd.run:
    - cwd: var/www/html
    - user: root
    - group: root
    - onchanges:
      - git: update_repo
    

"cp -r ./raml/ /var/www/html/repo/ && chown -R apache:apache /var/www/ && systemctl reload httpd":
  cmd.run:
    - cwd: /home/{{ pillar['git_user'] }}/git/MBEE-Repo/src/main/web/mms/
    - user: root
    - group: root
    - require:
      - cmd: "rm -rf ./repo"
    - onchanges:
      - git: update_repo