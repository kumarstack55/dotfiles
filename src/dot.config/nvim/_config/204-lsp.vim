if empty(globpath(&rtp, 'autoload/lsp.vim'))
  finish
endif

" 各行に警告メッセージを出力せず、ステータスに出力するための設定だが、
" 2021-04-25 時点で、Windows, Linux ともに設定が有効とならなかった。
"let g:lsp_diagnostics_echo_cursor = 1

" F2 で変数などの変更を行う
nmap <buffer> <f2> <plug>(lsp-rename)
