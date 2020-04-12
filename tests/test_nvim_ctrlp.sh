#!/bin/bash

set -eux

script_path=$(readlink -f $0)
script_dir=$(dirname $script_path)
source $script_dir/funcs.sh

cmd_file=$(my_mktemp -h cmd)
out_file=$(my_mktemp)

# ctrl-p でファイル名を選び、ファイルを編集し、終了する
cat <<__SEQ__ | tee $cmd_file
\<c-p>tests/run.sh\<CR>
:w! ${out_file}
:qa!
__SEQ__

cmd=$(my_get_normal_cmd "$cmd_file")
nvim -c "execute \"normal ${cmd}\"" 1>/dev/null 2>/dev/null

grep -q "find" "$out_file"
