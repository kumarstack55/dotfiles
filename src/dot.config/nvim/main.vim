" $HOME/.config/nvim/main.vim

let s:script_dir = expand('<sfile>:p:h')
let s:plugins_file = s:script_dir . "/plugins.vim"
execute "source " . s:plugins_file

" ------------------------------------------------------------
" コマンド定義

" フォントサイズを設定する
if dotfiles#is_gui_running()
  command! MyFontSizeSmall call dotfiles#set_gui_font(g:FONT_SIZE_SMALL)
  command! MyFontSizeNormal call dotfiles#set_gui_font(g:FONT_SIZE_NORMAL)
  command! MyFontSizeLarge call dotfiles#set_gui_font(g:FONT_SIZE_LARGE)
  command! MyFontSizeExLarge call dotfiles#set_gui_font(g:FONT_SIZE_EXLARGE)
endif

" tabstop, shiftwidth を変える
command! MyTabstopWidth2 call dotfiles#set_tabstop(2)
command! MyTabstopWidth3 call dotfiles#set_tabstop(3)
command! MyTabstopWidth4 call dotfiles#set_tabstop(4)

" ファイルタイプ用の設定にする
command! MyFiletypeMarkdown call dotfiles#set_filetype_markdown()
command! MyFiletypeRst call dotfiles#set_filetype_rst()

" カーソル行の直後にmodelineを加える
command! MyModelineAppend call dotfiles#add_modeline()

" Tagbar をリロードする
command! MyTagbarReload call dotfiles#tagbar_reload()

" ------------------------------------------------------------
" マウス操作

if dotfiles#is_gui_running()
  " すべてのモードでマウスを有効にする
  set mouse=a
endif

" Visualモード時に１文字選択する
" マウス動作をxtermライクのプロファイルにする
behave xterm

" ------------------------------------------------------------
" クリップボード

" 選択範囲をクリップボードに送る
" VISUALで選択した範囲は即座にクリップボードに送られる
if dotfiles#is_gui_running()
  " 選択範囲をコピーする
  set guioptions+=a
elseif dotfiles#is_vim()
  set clipboard=autoselect
else
  " autoselect を設定できない環境では
  " autoselect に近い設定を noremap で設定しておく

  " S-Insert でクリップボードをペーストする
  nnoremap <S-Insert> "*p
  inoremap <S-Insert> <ESC>"*pi

  " マウス左ボタンを離したらクリップボードにコピーする
  vnoremap <LeftRelease> "*ygv

  " 選択範囲を変えたらコピーする
  " カーソル移動のたびにコピーして選択しなおすのは高コストで、
  " 選択の行数が多いときに使用に耐えない
  " そこで、VISUALをやめるときだけコピーを行う
  vnoremap <ESC> "*ygv<ESC>
endif

" ------------------------------------------------------------
" ツールバー

if dotfiles#is_gui_running() && dotfiles#is_vim()
  " ツールバーを非表示にする
  set guioptions-=T
endif

" ------------------------------------------------------------
" 画面

" ビジュアルベルを無効にする
set novisualbell

if dotfiles#is_gui_running()
  " フォントサイズを設定する
  " また、プリント時に文字化けを回避するために追加した
  MyFontSizeNormal
endif

" カラースキームを設定する
"colorscheme apprentice
"colorscheme gruvbox
colorscheme iceberg

" 検索時にのようなサーチカウントを表示する 例: [1/5]
set shortmess-=S

" ------------------------------------------------------------
" バッファ管理

" split,close時、ウィンドウの自動リサイズを行わない
set noequalalways

" ------------------------------------------------------------
" プレビュー

" 置換時に置換結果のプレビューをプレビューウィンドウで表示する
if dotfiles#is_neovim()
  set inccommand=split
endif

" ------------------------------------------------------------
" バッファ

" 行番号を表示させない
set nonumber

if dotfiles#is_gui_running()
  " insert モードで IM を OFF にする
  set iminsert=0

  " 検索パタンを入力時、 IM を iminsert 設定値で設定する
  set imsearch=-1
endif

" 検索キーワードを強調させない
set nohlsearch

" ------------------------------------------------------------
" ファイルオープン

" バックアップファイル (*~) を作らない
set nobackup

" 同ファイルの複数編集に気づけるようスワップファイルを作る
set swapfile

" Windows環境では次のパスにスワップを作る
if dotfiles#is_windows()
  set directory=$TEMP,c:\\tmp,c:\\temp,.
endif

" undo ファイル (un~) を作らない
set noundofile

" 既存ファイル編集時のエンコーディング候補順序を定める
set fileencodings=utf-8,cp932,utf-16le

" ファイル再オープン時にカーソルを移動する
" (:help restore-cursor)
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" ------------------------------------------------------------
" 行

" modelineの認識は先頭と末尾の行数を指定する
set modelines=5

" カーソルの上下端で表示するスクリーン行数の最小数を指定する
set scrolloff=5

" カーソル行を表示させる
set cursorline

" 長い行を入力するときvimが改行を入れないようにする
set textwidth=0

" 折り畳み行の行頭に視覚的なインデントを入れる
if v:version > 704
  set breakindent
endif

" ------------------------------------------------------------
" ファイルタイプ

" *.yml
autocmd BufRead,BufNewFile *.yml
      \ setlocal indentexpr=""

" Ansible
autocmd BufRead,BufNewFile */playbooks/*.yml
      \ setlocal filetype=yaml.ansible
autocmd BufRead,BufNewFile */ansible/*.yml
      \ setlocal filetype=yaml.ansible

" config
autocmd BufRead,BufNewFile */dot.gitconfig_local.inc
      \ setlocal filetype=conf
autocmd BufRead,BufNewFile */.gitconfig_local.inc
      \ setlocal filetype=conf

" Markdwon
autocmd BufRead,BufNewFile *.md
  \ setlocal filetype=markdown shiftwidth=4 softtabstop=4
  \ tabstop=4 expandtab

" ------------------------------------------------------------
" プラグイン設定

" ~/.config/nvim/_config/*.vim 等を読み込む
" 各 *.vim で次のようにするとロード済みのプラグインなら設定される。
"   if empty(globpath(&rtp, 'autoload/nerdtree.vim'))
"     finish
"   endif
" vim-plug で on, for など遅延ロードをする場合、
" 起動時に読まれないので注意すること。
for val in sort(split(globpath(&runtimepath, '_config/*.vim')))
  execute('exec "so" val')
endfor
" 以下は vim 7.4 では動かなかったため、CentOS7系が死滅するまでコメントアウトする
"call
"  \ map(
"    \ sort(
"      \ split(
"        \ globpath(&runtimepath, '_config/*.vim')
"      \ )
"    \ ),
"    \ {->[execute('exec "so" v:val')]}
"  \ )
