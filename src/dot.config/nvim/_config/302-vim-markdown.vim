if empty(globpath(&runtimepath, 'syntax/markdown.vim'))
  finish
endif

" folding 設定を無効にする。
let g:vim_markdown_folding_disabled = 1

" 箇条項目の点を挿入しない。
let g:vim_markdown_auto_insert_bullets = 0

" コードブロックで powershell は ps1 として扱う。
let g:vim_markdown_fenced_languages = ["powershell=ps1"]
