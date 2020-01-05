# alias-vi.sh
if type nvim >/dev/null 2>&1; then
  alias vi=nvim
elif type vim >/dev/null 2>&1; then
  alias vi=vim
fi
