install_development_tools:
  pkg.installed:
    - pkgs:
      - bison
      - byacc
      - cscope
      - ctags
      - cvs
      - diffstat
      - doxygen
      - flex
      - gcc
      - gcc-c++
      - gcc-gfortran
      - gettext
      - git
      - indent
      - intltool
      - libtool
      - patch
      - patchutils
      - rcs
      - redhat-rpm-config
      - rpm-build
      - subversion
      - swig
      - systemtap
    - unless: rpm -q nodejs

install_nodesource_rpm:
  cmd.run:
    - name: curl -sL https://rpm.nodesource.com/setup | bash -
    - user: root
    - group: root
    - unless: rpm -q nodejs
    - require:
      - pkg: install_development_tools
      
node_js_pkg:
  pkg.installed:
    - name: nodejs
    
npm@latest:
  npm.installed:
    - require: 
      - pkg: nodejs
