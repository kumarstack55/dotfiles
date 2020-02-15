# env-editor.sh
if type nvim >/dev/null 2>&1; then
  if [[ $(uname -s) =~ ^MINGW64_NT ]]; then
    export EDITOR=vim
  else
    export EDITOR=nvim
  fi
elif type vim >/dev/null 2>&1; then
  export EDITOR=vim
elif type vi >/dev/null 2>&1; then
  export EDITOR=vi
fi
