if empty(globpath(&runtimepath, 'autoload/sonictemplate.vim'))
  finish
endif

let g:sonictemplate_vim_template_dir = expand('~/.vim/sonictemplate')
