#!/bin/bash

set -eux

script_path=$(readlink -f $0)
script_dir=$(dirname $script_path)
source $script_dir/funcs.sh

echo "ダブルクォートをシングルクォートにする"
vim_script_file=$(mktemp /tmp/tmp.XXXXXXXXXX.txt)
out_file=$(mktemp /tmp/tmp.XXXXXXXXXX.txt)
cat <<__TEXT__ | tee "$out_file"
"Hello world!"
__TEXT__
cat <<__VIM__ | tee "$vim_script_file"
:normal cs"'
:w!
:qa!
__VIM__
nvim -s "$vim_script_file" "$out_file" 1>/dev/null 2>/dev/null
grep -q "'Hello world!'" "$out_file"

echo "シングルクォートをHTMLタグに変える"
vim_script_file=$(mktemp /tmp/tmp.XXXXXXXXXX.txt)
out_file=$(mktemp /tmp/tmp.XXXXXXXXXX.txt)
cat <<__TEXT__ | tee "$out_file"
'Hello world!'
__TEXT__
cat <<__VIM__ | tee "$vim_script_file"
:normal cs'<q>
:w!
:qa!
__VIM__
nvim -s "$vim_script_file" "$out_file" 1>/dev/null 2>/dev/null
grep -q "<q>Hello world!</q>" "$out_file"

echo "HTMLタグをダブルクォートに変える"
vim_script_file=$(mktemp /tmp/tmp.XXXXXXXXXX.txt)
out_file=$(mktemp /tmp/tmp.XXXXXXXXXX.txt)
cat <<__TEXT__ | tee "$out_file"
<q>Hello world!</q>
__TEXT__
cat <<__VIM__ | tee "$vim_script_file"
:normal cst"
:w!
:qa!
__VIM__
nvim -s "$vim_script_file" "$out_file" 1>/dev/null 2>/dev/null
grep -q '"Hello world!"' "$out_file"
