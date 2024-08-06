if [ -x ~/.bashrc.d/alias/ ]; then
  for i in $(find ~/.bashrc.d/alias/ -type f ); do
    source "$i"
  done
fi
