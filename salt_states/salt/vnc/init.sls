GNOME:
  pkg.group_installed:
    - skip:
      - redhat-access-gui
      - gvfs-obexftp:q
    
install_vnc:
  pkg.installed:
    - names:
      - tigervnc
      - tigervnc-server
      - xorg-x11-fonts-Type1

  
