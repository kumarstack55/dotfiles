if empty(globpath(&runtimepath, 'syntax/ps1.vim'))
  finish
endif

" vim-ps1 と UltiSnips を同時に利用すると、コメント行の shift に失敗する。
" 回避するに smartindent を無効にする。
autocmd BufRead,BufNewFile *.ps1 setlocal nosmartindent
autocmd BufRead,BufNewFile *.psm1 setlocal nosmartindent
