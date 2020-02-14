# env-term.sh
if [[ ! $(uname -s) =~ ^MINGW64_NT ]]; then
  case "$TERM" in
    "xterm") TERM=xterm-256color;;
    *) ;;
  esac
fi
