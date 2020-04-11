#!/bin/bash

set -eux

script_path=$(readlink -f $0)
script_dir=$(dirname $script_path)
source $script_dir/funcs.sh

seq_file=$(mktemp /tmp/tmp.XXXXXXXXXX.txt)
out_file=$(mktemp /tmp/tmp.XXXXXXXXXX.txt)

cat <<__SEQ__ | tee $seq_file
:NERDTreeToggle
?
:w ${out_file}
:qa!
__SEQ__

cmd=$(get_normal_cmd "$seq_file")
nvim -c "execute \"normal ${cmd}\""
grep -q "^\" NERDTree" "$out_file"
