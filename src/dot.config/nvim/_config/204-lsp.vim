if empty(globpath(&runtimepath, 'autoload/lsp.vim'))
  finish
endif

" 各行に警告メッセージを出力せず、ステータスに出力するための設定だが、
" 2021-04-25 時点で、Windows, Linux ともに設定が有効とならなかった。
" Enables echo of diagnostic error for the current line to status. Requires
" |g:lsp_diagnostics_enabled| set to 1.
"let g:lsp_diagnostics_echo_cursor = 0
"let g:lsp_diagnostics_echo_cursor = 1

" 診断のハイライトを無効にする。
let g:lsp_diagnostics_highlights_enabled = 0
