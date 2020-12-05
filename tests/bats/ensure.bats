#!/usr/bin/env bats

load test_helper.bash

load_funcs() {
  # shellcheck source=../../bin/funcs.sh
  source "$(readlink -f "$BATS_TEST_DIRNAME/../../bin/funcs.sh")"
}

@test "echo_err は標準出力に出力しない" {
  load_funcs

  local f1
  f1=$(mktemp)
  echo_err line 1>"$f1"

  local stdout_lines
  mapfile -t stdout_lines <"$f1"

  [ "${#stdout_lines[*]}" -eq 0 ]
}

@test "echo_err は標準エラーに出力する" {
  load_funcs

  local f1
  f1=$(mktemp)
  echo_err line 2>"$f1"

  local stderr_lines
  mapfile -t stderr_lines <"$f1"

  [ "${#stderr_lines[*]}" -eq 1 ]
  [ "${stderr_lines[0]}" == "line" ]
}

@test "err_exit は異常終了する" {
  load_funcs
  run call_func_may_exit err_exit
  [ "$status" -ne 0 ]
}

@test "err_exit は標準エラーに出力する" {
  load_funcs

  local f1
  f1=$(mktemp)
  set +e
  call_func_may_exit err_exit line 2>"$f1"
  set -e

  local stderr_lines
  mapfile -t stderr_lines <"$f1"

  [ "${#stderr_lines[*]}" -eq 1 ]
  [ "${stderr_lines[0]}" == "line" ]
}

@test "ensure は引数実行結果が非ゼロのとき異常終了する" {
  load_funcs
  run call_func_may_exit ensure false
  [ "$status" -ne 0 ]
}

@test "ensure は引数実行結果がゼロのときゼロを返す" {
  load_funcs
  run call_func_may_exit ensure true
  [ "$status" -eq 0 ]
}

@test "ignore は引数実行結果がゼロのときゼロを返す" {
  load_funcs
  run ignore true
  [ "$status" -eq 0 ]
}

@test "ignore は引数実行結果が非ゼロのとき非ゼロを返す" {
  load_funcs
  run ignore false
  [ "$status" -ne 0 ]
}

@test "echo_abspath は相対パスをもとに絶対パスを出力する" {
  load_funcs

  local tmp_dir
  tmp_dir=$(mktemp -d)
  mkdir -p "$tmp_dir/d1/c/d2"
  cd "$tmp_dir/d1/c"

  run echo_abspath "./d2"
  [ "$status" -eq 0 ]
  [ "${#lines[*]}" -eq 1 ]
  [ "${lines[0]}" == "$tmp_dir/d1/c/d2" ]
}

@test "echo_abspath はpwdを指定すると絶対パスを出力する" {
  load_funcs

  local tmp_dir
  tmp_dir=$(mktemp -d)
  mkdir -p "$tmp_dir/d1/c/d2"
  cd "$tmp_dir/d1/c"

  run echo_abspath "."
  [ "$status" -eq 0 ]
  [ "${#lines[*]}" -eq 1 ]
  [ "${lines[0]}" == "$tmp_dir/d1/c" ]
}

@test "echo_abspath はpwdより上のディレクトリ指定で絶対パスを出力する" {
  load_funcs

  local tmp_dir
  tmp_dir=$(mktemp -d)
  mkdir -p "$tmp_dir/d1/c/d2"
  cd "$tmp_dir/d1/c"

  run echo_abspath ".."
  [ "$status" -eq 0 ]
  [ "${#lines[*]}" -eq 1 ]
  [ "${lines[0]}" == "$tmp_dir/d1" ]
}
