if dotfiles#version_ge_8()
  " https://github.com/dense-analysis
  " 5.ix. How can I navigate between errors quickly?
  nmap <silent> <C-k> <Plug>(ale_previous_wrap)
  nmap <silent> <C-j> <Plug>(ale_next_wrap)
endif
