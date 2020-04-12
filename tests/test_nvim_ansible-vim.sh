#!/bin/bash

set -eux

script_path=$(readlink -f $0)
script_dir=$(dirname $script_path)
source $script_dir/funcs.sh

vim_script_file=$(mktemp /tmp/tmp.XXXXXXXXXX.txt)
out_file=$(mktemp /tmp/tmp.XXXXXXXXXX.txt)

# ファイルが生成済みである
test -f $HOME/.vim/plugged/ansible-vim/UltiSnips/ansible.snippets

# failで保管するとmsgが補完される
cat <<__TEXT__ | tee "$out_file"
- name: x
  fail
# vim:set filetype=yaml.ansible:
__TEXT__

cat <<__VIM__ | tee "$vim_script_file"
:normal 2G\$
:execute "normal a\<Tab>\<c-j>\<Esc>"
:w!
:qa!
__VIM__
nvim -s "$vim_script_file" "$out_file" 1>/dev/null 2>/dev/null
grep -q "msg" "$out_file"
