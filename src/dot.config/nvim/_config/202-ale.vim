if empty(globpath(&runtimepath, 'autoload/ale.vim'))
  finish
endif

if v:version >= 800
  " https://github.com/dense-analysis
  " 5.ix. How can I navigate between errors quickly?
  nmap <silent> <C-k> <Plug>(ale_previous_wrap)
  nmap <silent> <C-j> <Plug>(ale_next_wrap)
endif
