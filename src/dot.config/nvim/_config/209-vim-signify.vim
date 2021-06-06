if empty(globpath(&runtimepath, 'autoload/sy.vim'))
  finish
endif

" git は GitGutter で行うため除外する。
let g:signify_skip = {'vcs': { 'deny': ['git'] }}
