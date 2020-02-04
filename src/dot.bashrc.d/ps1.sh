# ps1.sh
declare __my_ps1_prefix="__my_ps1_impl_"
declare __my_ps1_next_index=0

function __my_term_256_colors {
  case "$TERM" in
    "xterm-256color") return 0;;
    "screen-256color") return 0;;
    "tmux-256color") return 0;;
    *) return 1;;
  esac
}

function __my_ps1_impl_centos {
  export PS1='[\u@\h \W]\$ '
}

function __my_ps1_impl_date {
  if __my_term_256_colors; then
    PS1='\n\e[38;5;240m$(date "+%F %T")\e[39m\n[\u@\h \W]\$ '
  else
    PS1='\n$(date "+%F %T")\n[\u@\h \W]\$ '
  fi
  export PS1
}

function __my_ps1_impl_simple {
  export PS1='\u@\h:\W \$ '
}

function __my_ps1_impl_simple_date {
  if __my_term_256_colors; then
    PS1='\n\e[38;5;240m$(date "+%F %T")\e[39m\n\u@\h:\W \$ '
  else
    PS1='\n$(date "+%F %T")\n\u@\h:\W \$ '
  fi
  export PS1
}

function __my_ps1_funcs {
  declare -F | grep -o "$__my_ps1_prefix\S*"
}

function __my_ps1_find_index {
  local -a ps1_funcs=($(__my_ps1_funcs))
  local i
  for ((i=0; i < ${#ps1_funcs[@]}; i++)); do
    if [[ ${ps1_funcs[$i]} == "${__my_ps1_prefix}$1" ]]; then
      echo $i
      return 0
    fi
  done
  return 1
}

function my_ps1_switch {
  local -a ps1_funcs=($(__my_ps1_funcs))
  local f="${ps1_funcs[$__my_ps1_next_index]}"
  echo "Switched to $(echo $f | sed -e "s/^$__my_ps1_prefix//") PS1"
  eval "$f"
  let __my_ps1_next_index+=1
  if [[ $__my_ps1_next_index -ge ${#ps1_funcs[@]} ]]; then
    let __my_ps1_next_index=0
  fi
}

__my_ps1_next_index=$(__my_ps1_find_index simple)
