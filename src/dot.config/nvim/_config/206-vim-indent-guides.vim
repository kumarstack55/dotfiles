" バックグラウンドdarkにしてインデントガイドの色をよくする
set background=dark

" vim起動時に有効にする
let g:indent_guides_enable_on_vim_startup = 1

" サイズは1文字で表現する
let g:indent_guides_guide_size = 1

" nerdtree は除外する
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']
