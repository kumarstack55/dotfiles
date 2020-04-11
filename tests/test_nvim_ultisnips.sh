#!/bin/bash

set -eux

script_path=$(readlink -f $0)
script_dir=$(dirname $script_path)
source $script_dir/funcs.sh

seq_file=$(mktemp /tmp/tmp.XXXXXXXXXX.txt)
sh_file=$(mktemp /tmp/tmp.XXXXXXXXXX.sh)

# ファイルタイプ sh で #! 入力後にタブキーで補完される
cat <<__SEQ__ | tee $seq_file
i#!\<Tab>\<Tab>\<Esc>:wq!
__SEQ__
cmd=$(get_normal_cmd "$seq_file")
nvim -c "execute \"normal ${cmd}\"" "$sh_file" 1>/dev/null 2>/dev/null
grep -Fq "#!/usr/bin/env bash" "$sh_file"
