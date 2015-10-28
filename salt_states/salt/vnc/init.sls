"GNOME Desktop":
  pkg.group_installed
    
install_vnc:
  pkg.installed:
    - names:
      - tigervnc
      - tigervnc-server
      - xorg-x11-fonts-Type1

  
