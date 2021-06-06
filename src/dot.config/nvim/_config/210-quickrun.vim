if empty(globpath(&runtimepath, 'autoload/quickrun.vim'))
  finish
endif

" :QuickRun でその出力は vsplit でなく split にする。
let g:quickrun_config={'*': {'split': ''}}

" 新しいウィンドウを下に開く。
set splitbelow
