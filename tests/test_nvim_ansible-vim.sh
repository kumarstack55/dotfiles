#!/bin/bash

set -eux

script_path=$(readlink -f $0)
script_dir=$(dirname $script_path)
source $script_dir/funcs.sh

cmd_file=$(my_mktemp -h cmd -e txt)
yml_file=$(my_mktemp -h ansible-vim -e yml)

# ファイルタイプ sh で #! 入力後にタブキーで補完される
cat <<__YAML__ | tee "$yml_file"
- name: x
  fail
# vim:set ft=yaml.ansible:
__YAML__

cat <<'__SEQ__' | tee "$cmd_file"
2G$a\<Tab>\<c-j>\<Esc>:wq!
__SEQ__

cmd=$(my_get_normal_cmd "$cmd_file")
nvim -c "execute \"normal ${cmd}\"" "$yml_file" \
  1>/dev/null 2>/dev/null

grep -Fq "msg" "$yml_file"
