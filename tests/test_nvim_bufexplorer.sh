#!/bin/bash

set -eux

script_path=$(readlink -f $0)
script_dir=$(dirname $script_path)
source $script_dir/funcs.sh

cmd_file=$(my_mktemp -h cmd)
out_file=$(my_mktemp -h bufexplorer)

# :BufExplorer <F1> で BufExplorer のヘルプが表示される
cat <<__SEQ__ | tee "$cmd_file"
:BufExplorer
\<F1>:w! ${out_file}
:qa!
__SEQ__

cmd=$(my_get_normal_cmd "$cmd_file")
nvim -c "execute \"normal ${cmd}\"" 1>/dev/null 2>/dev/null

grep -q "^\" Buffer Explorer" "$out_file"
