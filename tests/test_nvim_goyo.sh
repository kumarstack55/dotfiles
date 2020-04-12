#!/bin/bash

set -eux

script_path=$(readlink -f $0)
script_dir=$(dirname $script_path)
source $script_dir/funcs.sh

seq_file=$(my_mktemp)
out_file=$(my_mktemp)
tmp_file=$(my_mktemp)

# テキストファイルを編集するとき、Goyoコマンドが定義されている
cat <<__SEQ__ | tee $seq_file
:redir! > ${out_file}
:filter Goyo command
:redir END
:qa!
__SEQ__

cmd=$(my_get_normal_cmd "$seq_file")
nvim -c "execute \"normal ${cmd}\"" $tmp_file \
  1>/dev/null 2>/dev/null

grep -q "Goyo" "$out_file"
