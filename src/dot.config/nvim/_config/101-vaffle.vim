if empty(globpath(&runtimepath, 'autoload\vaffle.vim'))
  finish
endif

" 選択したディレクトリに移動する。
let g:vaffle_auto_cd = 1
