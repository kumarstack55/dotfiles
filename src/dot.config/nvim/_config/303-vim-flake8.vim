if empty(globpath(&runtimepath, 'autoload/flake8.vim'))
  finish
endif

let g:flake8_show_in_gutter=1
