if [ -x ~/.bashrc.d/env/ ]; then
  for i in $(find ~/.bashrc.d/env/ -type f ); do
    source "$i"
  done
fi
