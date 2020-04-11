#!/bin/bash

set -eux

script_path=$(readlink -f $0)
script_dir=$(dirname $script_path)
source $script_dir/funcs.sh

seq_file=$(mktemp /tmp/tmp.XXXXXXXXXX.txt)
out_file=$(mktemp /tmp/tmp.XXXXXXXXXX.txt)
tmp_file=$(mktemp /tmp/tmp.XXXXXXXXXX.txt)

# テキストファイルを編集するとき、Goyoコマンドが定義されている
cat <<__SEQ__ | tee $seq_file
:redir! > ${out_file}
:filter Goyo command
:redir END
:qa!
__SEQ__
cmd=$(get_normal_cmd "$seq_file")
nvim -c "execute \"normal ${cmd}\"" $tmp_file 1>/dev/null 2>/dev/null
grep -q "Goyo" "$out_file"
