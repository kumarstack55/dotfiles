# alias-vim.sh
if type nvim >/dev/null 2>&1; then
  if type vim >/dev/null 2>&1; then
    if [[ ! $(uname -s) =~ ^MINGW64_NT ]]; then
      alias vim=nvim
    fi
  fi
fi
