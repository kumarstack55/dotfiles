if empty(globpath(&runtimepath, 'autoload/glaive.vim'))
  finish
endif

call glaive#Install()
