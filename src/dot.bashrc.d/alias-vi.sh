# alias-vi.sh
if type nvim >/dev/null 2>&1; then
  if [[ ! $(uname -s) =~ ^MINGW64_NT ]]; then
    alias vi=nvim
  fi
elif type vim >/dev/null 2>&1; then
  alias vi=vim
fi
