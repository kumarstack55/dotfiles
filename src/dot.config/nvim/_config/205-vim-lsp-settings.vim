if empty(globpath(&runtimepath, 'autoload/lsp_settings.vim'))
  finish
endif

" 各行に警告メッセージを出力せず、ステータスに出力するための設定だが、
" 2021-04-25 時点で、Windows, Linux ともに設定が有効とならなかった。
" 2022-05-15 再び設定してみたが変わらなかった。
" Enables echo of diagnostic error for the current line to status. Requires
" |g:lsp_diagnostics_enabled| set to 1.
"let g:lsp_diagnostics_echo_cursor = 0
"let g:lsp_diagnostics_echo_cursor = 1

" 診断のハイライトを無効にする。
let g:lsp_diagnostics_highlights_enabled = 0

let g:lsp_settings = {}

" Windows で ShellCheck を利用したいが、うまく動かず OS 問わず無効化しておく。
" ここは ALE を検討しようとしている。
let g:lsp_settings['bash-language-server'] = {
    \ 'disabled': 1
  \ }

function! s:set_lsp_pylsp_all_enable_mypy()
  let g:lsp_settings['pylsp-all'] = {
      \ 'workspace_config': {
        \ 'pylsp_mypy': {
          \ 'enabled': 1
        \ }
      \ }
    \ }
endfunction

function! s:set_lsp_pylsp_all_disable_mypy()
  let g:lsp_settings['pylsp-all'] = {
      \ 'workspace_config': {
      \ }
    \ }
endfunction

" pyls-mypy からフォークした pylsp-mypy を使う。
" LspInstallServer を実行後 pylsp-mypy が利用する venv で、
" pip install pylsp-mypy を実行する必要がある。
" Windows であれば venv は次のパスにありそう。
" $HOME\AppData\Local\vim-lsp-settings\servers\pylsp-all\venv
" 参考: https://qiita.com/tk0miya/items/5a5beb2586c63792ce10
call s:set_lsp_pylsp_all_enable_mypy()

" おそらく以下の切り替えは Python ファイルを開く前に対処する必要がありそう。
" いっそ無効にするために pip uninstall mypy したほうがいいかもしれない。
command! MyLspMypyEnable call s:set_lsp_pylsp_all_enable_mypy()
command! MyLspMypyDisable call s:set_lsp_pylsp_all_disable_mypy()

" --log-file は $HOME 等に配置したいが ~/pylsp.log を指定すると機能しない。
" 必要な時に次を利用する。
"let g:lsp_settings['pylsp-all']['args'] = ['--log-file=pylsp.log', '-vvv']
