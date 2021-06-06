if empty(globpath(&runtimepath, 'autoload/nerdfont.vim'))
  finish
endif

let g:fern#renderer = "nerdfont"
