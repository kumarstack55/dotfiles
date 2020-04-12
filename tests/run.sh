#!/bin/bash

set -eu

script_path=$(readlink -f $0)
script_dir=$(dirname $script_path)
source "$script_dir/funcs.sh"

txt_file=$(my_mktemp -h find)

find "$script_dir" -type f -executable -name "test_*.sh" \
  >"$txt_file"

for test_path in $(cat "$txt_file"); do
  echo "test_path: $test_path"
  timeout 10s $test_path
done

echo "ok"
