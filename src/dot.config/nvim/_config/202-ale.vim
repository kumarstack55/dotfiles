" ale は vim-plug により sh のみロードされる。
" そのため、設定は常に行う。
"if empty(globpath(&runtimepath, 'autoload/ale.vim'))
"  finish
"endif

if v:version >= 800
  " https://github.com/dense-analysis
  " 5.ix. How can I navigate between errors quickly?
  nmap <silent> <C-k> <Plug>(ale_previous_wrap)
  nmap <silent> <C-j> <Plug>(ale_next_wrap)
endif

" Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1

let g:ale_linters = {
    \ 'sh': ['shellcheck'],
  \ }
    "\ 'sh': ['bashate', 'language_server', 'shell', 'shellcheck'],

"let g:ale_sign_column_always = 1
"let g:ale_sign_error = '>>'
"let g:ale_sign_warning = '--'
"let g:ale_echo_msg_error_str = 'E'
"let g:ale_echo_msg_warning_str = 'W'
"let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
