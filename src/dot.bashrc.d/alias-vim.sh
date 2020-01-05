# alias-vim.sh
if type nvim >/dev/null 2>&1; then
  if type vim >/dev/null 2>&1; then
    alias vim=nvim
  fi
fi
