#!/bin/bash
declare __my_ps1_prefix="__my_ps1_impl_"
declare __my_ps1_next_index=0
declare __my_ps1_original="$PS1"

__my_term_256_colors() {
  case "$TERM" in
    "xterm-256color") return 0;;
    "screen-256color") return 0;;
    "tmux-256color") return 0;;
    *) return 1;;
  esac
}

__my_ps1_impl_110_date() {
  local prefix
  if __my_term_256_colors; then
    # shellcheck disable=SC2016
    prefix='\n\[\e[38;5;240m\]`date "+%F %T"`\[\e[39m\]'
  else
    # shellcheck disable=SC2016
    prefix='\n`date "+%F %T"`'
  fi
  export PS1="${prefix}${__my_ps1_original}"
}

__my_ps1_impl_120_simple2() {
  export PS1='\W \$ '
}

__my_ps1_impl_130_simple3() {
  export PS1='\$ '
}

__my_ps1_impl_900_original() {
  export PS1="${__my_ps1_original}"
}

__my_ps1_funcs() {
  declare -F | grep -o "$__my_ps1_prefix\S*"
}

__my_ps1_find_index() {
  local -a ps1_funcs
  mapfile -t ps1_funcs < <(__my_ps1_funcs)
  local i
  for ((i=0; i < ${#ps1_funcs[@]}; i++)); do
    if [[ ${ps1_funcs[$i]} == "${__my_ps1_prefix}$1" ]]; then
      echo "$i"
      return 0
    fi
  done
  return 1
}

my_ps1_switch() {
  local -a ps1_funcs
  mapfile -t ps1_funcs < <(__my_ps1_funcs)
  local f
  f="${ps1_funcs[$__my_ps1_next_index]}"
  eval "$f"
  echo "Switched to ${f//__my_ps1_prefix/}"
  __my_ps1_next_index=$((__my_ps1_next_index+1))
  if [[ $__my_ps1_next_index -ge ${#ps1_funcs[@]} ]]; then
    __my_ps1_next_index=0
  fi
}

my_prompt_switch() {
  my_ps1_switch
}