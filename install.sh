#!/bin/bash
if [ "$UID" = 0 ]; then
  programDir="$(dirname "$0")"
  [ -z "$DESTDIR" ] && DESTDIR=/
  [ -z "$PREFIX" ] && PREFIX=/usr
  cd "$programDir"
  echo "Installing 'softwaves-manjaro' plymouth theme ..."
  mkdir -p "$DESTDIR"/"$PREFIX"/share/plymouth/themes
  cp -r softwaves-manjaro "$DESTDIR"/"$PREFIX"/share/plymouth/themes/
  echo "Applying 'softwaves-manjaro' plymouth theme ..."
  if which plymouth-set-default-theme &>/dev/null; then
    plymouth-set-default-theme -R softwaves-manjaro
  elif which update-alternatives update-initramfs &>/dev/null; then
    update-alternatives --install "$DESTDIR"/"$PREFIX"/share/plymouth/themes/default.plymouth default.plymouth "$DESTDIR"/"$PREFIX"/share/plymouth/themes/softwaves-manjaro/softwaves-manjaro.plymouth 10
    update-alternatives --set default.plymouth "$DESTDIR"/"$PREFIX"/share/plymouth/themes/softwaves-manjaro/softwaves-manjaro.plymouth
    update-initramfs -u
  else
    echo "Could not apply the theme automatically!"
    echo "Please! Apply it manually."
    exit 2
  fi
else
  if which sudo &> /dev/null; then
    sudo --preserve-env=DESTDIR,PREFIX "$0"
  else
    echo "Please! Run this script as root."
    exit 1
  fi
fi
