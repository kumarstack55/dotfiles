#!/bin/bash

set -eux

script_path=$(readlink -f $0)
script_dir=$(dirname $script_path)
source $script_dir/funcs.sh

vim_script_file=$(my_mktemp -h apprentice -e vim)
out_file=$(my_mktemp -h apprentice)

# colorsheme一覧に apprentice が存在する
cat <<__VIM__ | tee "$vim_script_file"
:let c = getcompletion('', 'color')
:put =c
:w! $out_file
:qa!
__VIM__

nvim -s "$vim_script_file" 1>/dev/null 2>/dev/null

grep -qw "apprentice" "$out_file"
