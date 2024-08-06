if [ -x ~/.bashrc.d/functions/ ]; then
  for i in $(find ~/.bashrc.d/functions/ -type f ); do
    source "$i"
  done
fi
