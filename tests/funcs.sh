#!bash

function get_normal_cmd() {
  local seq_file="$1"; shift
  cat "$seq_file" | sed -e 's/$/\\<CR>/' | tr -d '\n'
}
