if empty(globpath(&rtp, 'autoload/lsp.vim'))
  finish
endif

" 各行に警告メッセージを出力せず、ステータスに出力する
" ただし、少なくとも Windows 環境では機能していないように見える
let g:lsp_diagnostics_echo_cursor = 1

" F2 で変数などの変更を行う
nmap <buffer> <f2> <plug>(lsp-rename)
