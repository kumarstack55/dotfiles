# .bashrc_local.sh
if [[ -e $HOME/.bashrc.d ]]; then
  for f in $(find $HOME/.bashrc.d/ | sort | grep \.sh$); do
    source $f
  done
fi
