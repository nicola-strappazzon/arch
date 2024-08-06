if [ -x ~/.bashrc.d ]; then
  for i in ~/.bashrc.d/*.sh; do
    if [ -f "$i" ]; then
      . "$i"
    fi
  done
fi
