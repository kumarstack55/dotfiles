if empty(globpath(&runtimepath, 'autoload/lsp_settings.vim'))
  finish
endif

" Windows で ShellCheck を利用したいが、
" うまく動かなかったため、OS 問わず無効化を試みる。
" ALE を検討しようとしている。
let g:lsp_settings = {
    \ 'bash-language-server': {'disabled': 1}
  \ }
