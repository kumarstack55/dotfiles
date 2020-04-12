#!bash

function my_get_normal_cmd() {
  local seq_file="$1"; shift
  cat "$seq_file" | sed -e 's/$/\\<CR>/' | tr -d '\n'
}

function my_mktemp() {
  local ext="txt"
  local dir="/tmp"
  local hint=""
  local tmpl_base="XXXXXXXXXX"
  local opt

  while getopts -- "D:e:h:t:" opt; do
    case $opt in
      D) dir="$OPTARG";;
      e) ext="$OPTARG";;
      h) hint="$OPTARG";;
      t) tmpl_base="$OPTARG";;
      \?) exit 1;;
    esac
  done
  shift $((OPTIND-1))

  if [[ $# -ne 0 ]]; then
    exit 1
  fi

  local hint_dot=""
  if [[ $hint != "" ]]; then
    hint_dot="${hint}."
  fi
  local tmpl="${dir}/${hint_dot}${tmpl_base}.${ext}"

  mktemp "$tmpl"
}
