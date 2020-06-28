if empty(globpath(&rtp, 'autoload/lsp.vim'))
  finish
endif

" F2 で変数などの変更を行う
nmap <buffer> <f2> <plug>(lsp-rename)
