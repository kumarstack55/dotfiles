" $HOME/.config/nvim/ginit.vim

" nvim-qt かどうかを判定するために変数を定義する。
" ただし、 init.vim のロード後に ginit.vim がロードされるようで、
" init.vim 内では利用できないことに注意が必要である。
let g:ginit_loaded = 1

" フォントサイズを設定する。
call dotfiles#define_font_size_commands()
MyFontSizeNormal
