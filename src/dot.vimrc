" $HOME/.vimrc

" _config/*.vim の設定を読み込むために runtimepath を利用している。
" vim も同様に設定を読み込むため runtimepath にパスを加える。
set runtimepath+=$HOME/.config/nvim
source $HOME/.config/nvim/main.vim
