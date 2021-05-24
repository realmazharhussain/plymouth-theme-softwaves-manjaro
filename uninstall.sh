#!/bin/bash
if [ "$UID" = 0 ]; then
  [ -z "$DESTDIR" ] && DESTDIR=/
  [ -z "$PREFIX" ] && PREFIX=/usr
  echo "Removing 'softwaves-manjaro' plymouth theme ..."
  if [ -d "$DESTDIR"/"$PREFIX"/share/plymouth/themes/softwaves-manjaro ]; then
    rm -r "$DESTDIR"/"$PREFIX"/share/plymouth/themes/softwaves-manjaro && echo "Done."
    if which plymouth-set-default-theme &>/dev/null; then
      echo -e "\nNote: 'softwaves-manjaro' may still be the current plymouth theme."
      echo -e "      To change plymouth theme run the command 'sudo plymouth-set-default-theme -R [theme-name]"
      echo -e "      To list all available plymouth themes run 'plymouth-set-default-theme -l'"
    elif which update-alternatives update-initramfs &>/dev/null; then
      echo "Applying default plymouth theme ..."
      update-alternatives --remove default.plymouth "$DESTDIR"/"$PREFIX"/share/plymouth/themes/softwaves-manjaro/softwaves-manjaro.plymouth
      update-initramfs -u
      echo "Done."
    else
      echo -e "\tNote: It seems, you applied this theme manually."
      echo -e "      If that's so, there is a high chance that 'softwaves-manjaro' is still the current plymouth theme and you need to manually apply another theme."
    fi
  else
    echo "Cannot uninstall 'softwaves-manjaro' plymouth theme. It is not installed"
  fi
else
  if which sudo &> /dev/null; then
    sudo --preserve-env=DESTDIR,PREFIX "$0"
  else
    echo "Please! Run this script as root."
    exit 1
  fi
fi
