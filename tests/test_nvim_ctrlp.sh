#!/bin/bash

set -eux

script_path=$(readlink -f $0)
script_dir=$(dirname $script_path)
source $script_dir/funcs.sh

seq_file=$(mktemp /tmp/tmp.XXXXXXXXXX.txt)
out_file=$(mktemp /tmp/tmp.XXXXXXXXXX.txt)

# ctrl-p でファイル名を選び、ファイルを編集し、終了する
cat <<__SEQ__ | tee $seq_file
\<c-p>tests/run.sh\<CR>
:w! ${out_file}
:qa!
__SEQ__
cmd=$(get_normal_cmd "$seq_file")
nvim -c "execute \"normal ${cmd}\"" 1>/dev/null 2>/dev/null
grep -q "find" "$out_file"
