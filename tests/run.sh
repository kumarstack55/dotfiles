#!/bin/bash

set -eu

script_path=$(readlink -f $0)
script_dir=$(dirname $script_path)
for test_path in $(find "$script_dir" -type f -executable -name "test_*.sh"); do
  echo "test_path: $test_path"
  $test_path
done
