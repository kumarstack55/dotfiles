if empty(globpath(&runtimepath, 'autoload/doge.vim'))
  finish
endif

let g:doge_doc_standard_python = 'google'

" デフォルト値だが指定なしに補完されなかった
" 明示指定する
let g:doge_doc_standard_sh = 'google'
