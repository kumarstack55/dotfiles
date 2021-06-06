if empty(globpath(&runtimepath, 'after\syntax\bats.vim'))
  finish
endif

let g:bats_vim_consider_dollar_as_part_of_word = 0
