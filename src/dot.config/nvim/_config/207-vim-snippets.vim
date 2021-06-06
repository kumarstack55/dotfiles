if empty(globpath(&runtimepath, 'autoload/vim_snippets.vim'))
  finish
endif

" 他にもスニペット管理があるが、
" ansible-vim のディレクトリ名にあわせて UltiSnips を選択した。

command! MyUltiSnipsRefreshSnippets
      \ call UltiSnips#RefreshSnippets()

" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
