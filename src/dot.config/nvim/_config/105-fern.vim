if empty(globpath(&runtimepath, 'autoload/fern.vim'))
  finish
endif

let g:fern#renderer = "nerdfont"
