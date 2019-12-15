" $HOME/.config/nvim/main.vim

" OSを判定する
let s:OS_TYPE_UNKNOWN = 0
let s:OS_TYPE_WINDOWS = 'Windows'
let s:OS_TYPE_LINUX = 'Linux'
let s:OS_TYPE_MAC_OS = 'macOS'
function! s:MyGetOsType()
  if has('win32')
    return s:OS_TYPE_WINDOWS
  endif
  let uname = substitute(system('uname'), '\n', '', '')
  if uname == 'Linux'
    return s:OS_TYPE_LINUX
  elseif uname == 'Darwin'
    return s:OS_TYPE_MAC_OS
  endif
  return s:OS_TYPE_UNKNOWN
endfunction
let g:my_os_type = s:MyGetOsType()

" GUI/CLIを判定する
let s:GUI_TYPE_RUNNING = 'running'
let s:GUI_TYPE_NOT_RUNNING = 'not running'
function! s:MyGetOsType()
  if has('gui_running')
    return s:GUI_TYPE_RUNNING
  endif
  return s:GUI_TYPE_NOT_RUNNING
endfunction
let g:my_gui_type = s:MyGetOsType()

" vim, neovimを判定する
let s:VIM_TYPE_NEOVIM = 'NeoVim'
let s:VIM_TYPE_VIM = 'Vim'
function! s:MyGetVimType()
  if has('nvim')
    return s:VIM_TYPE_NEOVIM
  endif
  return s:VIM_TYPE_VIM
endfunction
let g:my_vim_type = s:MyGetVimType()

" 有効にする機能を決定する
function! s:MyGetEnableDevIcons()
  if g:my_vim_type == s:VIM_TYPE_NEOVIM
    return 1
  endif
  if g:my_gui_type == s:GUI_TYPE_RUNNING
    return 1
  endif
  return 0
endfunction
let g:enable_devicons = s:MyGetEnableDevIcons()

" Python36 を読む
if g:my_os_type == s:OS_TYPE_WINDOWS
  if g:my_vim_type == s:VIM_TYPE_NEOVIM
    let g:loaded_python_provider = 0
    let s:python3_path = 'C:\Python36\python.exe'
    if executable(s:python3_path)
      let g:python3_host_prog = s:python3_path
    endif
  endif
  if g:my_vim_type == s:VIM_TYPE_VIM
    set pythonthreedll=C:\Python36\python36.dll
  endif
endif

" Python2 は読まない
if g:my_os_type == s:OS_TYPE_WINDOWS && g:my_vim_type == s:VIM_TYPE_NEOVIM
  let g:loaded_python_provider = 0
endif

" プラグインをインストールする
call plug#begin('~/.vim/plugged')
  " a universal set of defaults that (hopefully)
  " everyone can agree on.
  Plug 'tpope/vim-sensible'

  " NERDTree
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

  " This adds syntax for nerdtree on most common file extensions.
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight',
        \ { 'on': 'NERDTreeToggle' }

  " Distraction-free writing in Vim.
  Plug 'junegunn/goyo.vim', { 'for': 'markdown' }

  " A dark, low-contrast, Vim colorscheme.
  Plug 'romainl/Apprentice'

  " EditorConfig Vim Plugin
  Plug 'editorconfig/editorconfig-vim'

  " *submode.txt* Create your own submodes
  Plug 'kana/vim-submode'

  " Vim plugin that displays tags in a window, ordered by scope
  Plug 'majutsushi/tagbar', { 'for': ['markdown', 'python', 'rst'] }

  " Generate ctags-compatible tags files for Markdown documents.
  Plug 'jszakmeister/markdown2ctags', { 'for': ['markdown'] }

  " vimfiler - A powerful file explorer implemented in Vim script
  Plug 'Shougo/vimfiler.vim'

  " The unite or unite.vim plug-in can search and display
  " information from arbitrary sources like files, buffers,
  " recently used files or registers.
  Plug 'Shougo/unite.vim'

  " ctrlp.vim - Full path fuzzy file, buffer, mru, tag, ...
  " finder for Vim.
  Plug 'ctrlpvim/ctrlp.vim'

  " BufExplorer Plugin for Vim
  Plug 'jlanzarotta/bufexplorer'

  " lightline.vim - A light and configurable statusline/tabline
  " plugin for Vim
  Plug 'itchyny/lightline.vim'

  " Indent Guides is a plugin for visually displaying indent
  " levels in Vim.
  Plug 'nathanaelkane/vim-indent-guides'

  " quickrun.txt - Run a command and show its result quickly.
  Plug 'thinca/vim-quickrun'

  " A vim plugin to give you some slime.
  if g:my_os_type == s:OS_TYPE_LINUX
    Plug 'jpalardy/vim-slime'
  endif

  " Surround.vim is all about "surroundings": parentheses,
  " brackets, quotes, XML tags, and more.
  Plug 'tpope/vim-surround'

  " fugitive.vim may very well be the best Git wrapper of all time.
  Plug 'tpope/vim-fugitive'

  " A Vim plugin which shows a git diff in the gutter
  " (sign column and stages/undoes hunks.
  Plug 'airblade/vim-gitgutter'

  " This repository contains snippets files for various
  " programming languages.
  Plug 'honza/vim-snippets'

  " A vim plugin for syntax highlighting Ansible's common filetypes
  Plug 'pearofducks/ansible-vim',
        \ { 'for': 'yaml.ansible' }

  " Vim script for text filtering and alignment
  Plug 'godlygeek/tabular'

  " Syntax highlighting, matching rules and mappings
  " for the original Markdown and extensions.
  Plug 'plasticboy/vim-markdown',
        \ { 'for': ['md', 'text'] }

  " It provides nice syntax coloring and indenting
  " for Windows PowerShell (.ps1 files, and also includes
  " a filetype plugin so Vim can autodetect your PS1 scripts.
  Plug 'PProvost/vim-ps1',
        \ { 'for': ['ps1', 'psm'] }

  " A simple script to help create ctags-compatible tag files
  " for the sections within a reStructuredText document.
  Plug 'jszakmeister/rst2ctags'

  " Flake8 plugin for Vim
  Plug 'nvie/vim-flake8',
        \ { 'for': 'python' }

  if has('python3')
    " UltiSnips is the ultimate solution for snippets in Vim.
    Plug 'SirVer/ultisnips'
  endif

  " VimDevIcons - Add Icons to Your Plugins
  "Plug 'ryanoasis/vim-devicons'
  if g:enable_devicons
    Plug 'ryanoasis/vim-devicons'
  endif

call plug#end()

" フォントサイズを設定する
if g:my_os_type == s:OS_TYPE_WINDOWS
  let s:FONT_SIZE_SMALL = 10
  let s:FONT_SIZE_NORMAL = 12
  let s:FONT_SIZE_LARGE = 16
  let s:FONT_SIZE_EXLARGE = 20
  let s:FONT_SIZE_DEFAULT = s:FONT_SIZE_NORMAL

  " nvim-qt はフォント設定が可能だが、
  " nvim-qt と nvim を区別する手段がない
  " そこで nvim であればファンクション MySetGuiFont を定義する
  if g:my_gui_type == s:GUI_TYPE_RUNNING
    function! s:MySetGuiFont(font_size)
      let &guifont = 'Cica:h' . a:font_size . ':cSHIFTJIS:qDRAFT'
    endfunction
  endif
  if g:my_vim_type == s:VIM_TYPE_NEOVIM
    function! s:MySetGuiFont(font_size)
      let &guifont = 'Cica:h' . a:font_size
    endfunction
  endif
  command! MyFontSizeSmall call s:MySetGuiFont(s:FONT_SIZE_SMALL)
  command! MyFontSizeNormal call s:MySetGuiFont(s:FONT_SIZE_NORMAL)
  command! MyFontSizeLarge call s:MySetGuiFont(s:FONT_SIZE_LARGE)
  command! MyFontSizeExLarge call s:MySetGuiFont(s:FONT_SIZE_EXLARGE)
endif

" インデントガイドが無効か確認する
function! s:MyIndentGuideDisabled()
  call indent_guides#init_matches()
  return empty(w:indent_guides_matches)
endfunction

" インデントガイドが有効か確認する
function! s:MyIndentGuideEnabled()
  return ! s:MyIndentGuideDisabled()
endfunction

" インデントガイドをリロードする
function! MyIndentGuideReload()
  if s:MyIndentGuideEnabled()
    IndentGuidesDisable
    IndentGuidesEnable
  endif
endfunction
command! MyIndentGuideReload call MyIndentGuideReload()

" タブストップを変える
function! s:MySetLocalTabstop(ts)
  let &l:tabstop = a:ts
  let &l:shiftwidth = a:ts
  let &l:softtabstop = a:ts
  setlocal expandtab
  call MyIndentGuideReload()
endfunction
command! MyTabstopWidth2 call s:MySetLocalTabstop(2)
command! MyTabstopWidth3 call s:MySetLocalTabstop(3)
command! MyTabstopWidth4 call s:MySetLocalTabstop(4)

" Markdown編集用の設定にする
function! MyFileTypeMarkdown()
  setlocal filetype=markdown
  call s:MySetLocalTabstop(3)
endfunction
command! MyFileTypeMarkdown call MyFileTypeMarkdown()

" ReStructuredText用の設定にする
function! MyFileTypeRst()
  setlocal filetype=rst
  call s:MySetLocalTabstop(3)
endfunction
command! MyFileTypeRst call MyFileTypeRst()

" カーソル行の直後にmodelineを加える
function! MyModelineAppend()
  let pos = getpos(".")
  let modeline = "vim:set ft=" . &filetype . ":"
  let line = ""
  if &filetype == ""
    return
  elseif &filetype == "markdown"
    let line = "<!-- " . modeline . " -->"
  elseif &filetype == "rst"
    let line = ".. " . modeline
  else
    let line = modeline
  endif
  execute ":normal A\n" . line
  call setpos(".", pos)
endfunction
command! MyModelineAppend call MyModelineAppend()

" Tagbar をリロードする
function! MyTagbarReload()
  if exists('t:tagbar_buf_name') && bufwinnr(t:tagbar_buf_name) != -1
    TagbarClose
    TagbarOpen
  endif
endfunction
command! MyTagbarReload call MyTagbarReload()

" すべてのモードでマウスを有効にする
set mouse=a
behave mswin

" split,close時、ウィンドウの自動リサイズを行わない
set noequalalways

" ビジュアルベルを無効にする
set novisualbell

" 行番号を表示させる
set number

" カラースキームを設定する
colorscheme apprentice

if g:my_gui_type == s:GUI_TYPE_RUNNING ||
      \ g:my_vim_type == s:VIM_TYPE_NEOVIM
  " フォントサイズを設定する
  " また、プリント時に文字化けを回避するために追加した
  MyFontSizeNormal
endif

if g:my_gui_type == s:GUI_TYPE_RUNNING
  " ツールバーを非表示にする
  set guioptions-=T

  " insert モードで IM を OFF にする
  set iminsert=0

  " 検索パタンを入力時、 IM を iminsert 設定値で設定する
  set imsearch=-1
endif

" 既存ファイル編集時のエンコーディング候補順序を定める
set fileencodings=utf-8,cp932,utf-16le

" ファイル再オープン時にカーソルを移動する (:help restore-cursor)
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" modelineの認識は先頭と末尾の行数を指定する
set modelines=5

" カーソルの上部または下部で表示するスクリーン行数の最小数を指定する
set scrolloff=5

" カーソル行を表示させる
set cursorline

" 長い行を入力するときvimが改行を入れないようにする
set textwidth=0

" 折り畳み行の行頭に視覚的なインデントを入れる
if v:version > 704
  set breakindent
endif

" 選択範囲をクリップボードに送る
" VISUALで選択した範囲は即座にクリップボードに送られる
if g:my_gui_type == s:GUI_TYPE_RUNNING
  set clipboard=autoselect
else
  " autoselect を設定できない環境では
  " autoselect に近い設定を noremap で設定しておく

  " S-Insert でクリップボードをペーストする
  nnoremap <S-Insert> "*p
  inoremap <S-Insert> <ESC>"*pi

  " 選択を開始したらコピーする
  nnoremap v v"*ygv
  nnoremap V V"*ygv

  " マウス左ボタンを離したらクリップボードにコピーする
  vnoremap <LeftRelease> "*ygv

  " 選択範囲を変えたらコピーする
  " カーソル移動のたびにコピーして選択しなおすのは高コストで、
  " 選択の行数が多いときに使用に耐えない
  " そこで、VISUALをやめるときだけコピーを行う
  vnoremap <ESC> "*ygv<ESC>
endif

" 検索キーワードを強調させない
set nohlsearch

" 置換時に置換結果のプレビューをプレビューウィンドウで表示する
if g:my_vim_type == s:VIM_TYPE_NEOVIM
  set inccommand=split
endif

" バックアップファイル (*~) を作らない
set nobackup

" 同ファイルの複数編集に気づけるようスワップファイルを作る
set swapfile

" Windows環境では次のパスにスワップを作る
if g:my_os_type == s:OS_TYPE_WINDOWS
  set directory=$TEMP,c:\\tmp,c:\\temp,.
endif

" undo ファイル (un~) を作らない
set noundofile

"-----------------------------------------
" submode

" ウィンドウの大きさを C-w <>+- で変更する
call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>+')
call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>-')
call submode#map('winsize', 'n', '', '>', '<C-w>>')
call submode#map('winsize', 'n', '', '<', '<C-w><')
call submode#map('winsize', 'n', '', '+', '<C-w>+')
call submode#map('winsize', 'n', '', '-', '<C-w>-')

" 使い方
" vim
" :vsplit
" :split
" C-w +++---
" C-w >>><<<

"-----------------------------------------
" NERDTree

let NERDTreeShowBookmarks = 1   " 開始時にブックマークを表示
let NERDTreeShowHidden = 1      " 隠しファイルを表示
let NERDTreeSortHiddenFirst = 1 " 隠しファイルは先頭に表示

" 使い方
" :NERDTree

"-----------------------------------------
" VimFiler

" 使い方
" :VimFiler

"-----------------------------------------
" unite

" 使い方
" :Unite file buffer

"-----------------------------------------
" ctrlp.vim

" 使い方
" C-p 後に編集したいファイル名の一部を入力する

"-----------------------------------------
" vim-devicons

set encoding=utf8    " vim内で使うエンコーディングを指定する
set ambiwidth=double " East Asian Width Class Ambiguous を2文字幅で扱う

if g:enable_devicons
  if g:my_os_type == s:OS_TYPE_WINDOWS &&
        \ g:my_gui_type == s:GUI_TYPE_RUNNING
    " gvim で encoding=utf8 かつメニューを日本語で表示させると、
    " 表示がおかしくなるため、英語表示とする。
    set langmenu=en_US
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
  endif

  " フォルダアイコンの表示をON
  let g:WebDevIconsUnicodeDecorateFolderNodes = 1
endif

"-----------------------------------------
" bufexplorer

" 使い方
" :BufExplorer

"-----------------------------------------
" lightline.vim

set laststatus=2 " 常にステータスを表示させる
let g:lightline = {
  \ 'colorscheme': 'jellybeans',
  \ 'active': {
  \   'left': [ [ 'paste' ], [ 'fugitive', 'filename' ] ],
  \   'right': [
  \     ['filetype', 'fileencoding', 'fileformat'], ['percent'],
  \     ['lineinfo']
  \   ]
  \ },
  \ 'component_function': {
  \   'fileformat': 'LightLineFileformat',
  \   'filename': 'LightLineFilename',
  \   'filetype': 'LightLineFiletype',
  \   'fugitive': 'LightLineFugitive',
  \   'lineinfo': 'LightLineLineColumnInfo',
  \   'modified': 'LightLineModified',
  \   'percent': 'LightLinePercent',
  \   'readonly': 'LightLineReadonly',
  \ },
  \ 'separator': { 'left': '' },
  \ 'subseparator': { 'left': '|', 'right': '|' }
  \ }

function! LightLinePercent()
  return printf('L%d/%d:%3d%%',
        \ line('.'), line('$'), line('.')*100/line('$'))
endfunction

function! LightLineFugitive()
  if exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? (g:enable_devicons ? '' : '') . _ : ''
  endif
  return ''
endfunction

function! LightLineReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return g:enable_devicons ? "" : "[RO]"
  else
    return ""
  endif
endfunction

function! LightLineModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunction

function! LightLineFilename()
  return ('' != LightLineReadonly() ? LightLineReadonly().' ' : '').
    \ ('' != expand('%:t') ? expand('%:t') : '[No Name]').
    \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFiletype()
  return
    \ winwidth(0) > 70 ? (
    \   strlen(&filetype) ?
    \     &filetype . (
    \       g:enable_devicons ?
    \         ' ' . WebDevIconsGetFileTypeSymbol() : ''
    \     ) : 'no ft'
    \   ) :
    \   strlen(&filetype) ? (
    \     g:enable_devicons ?
    \       WebDevIconsGetFileTypeSymbol() : ''
    \     ) : ''
endfunction

function! LightLineFileformat()
  return
    \ winwidth(0) > 70 ? (
    \   &fileformat . (
    \       g:enable_devicons ?
    \       ' ' . WebDevIconsGetFileFormatSymbol()
    \       : ''
    \     )
    \   ) :
    \   (g:enable_devicons ? WebDevIconsGetFileFormatSymbol() : '')
endfunction

function! LightLineLineColumnInfo()
  " カーソル位置を得る
  let p = getpos(".")

  " ウィンドウの幅を得る
  redir =>a |exe "sil sign place buffer=".bufnr('')|redir end
  let signlist = split(a, '\n')
  let width = winwidth(0) -
    \ ((&number||&relativenumber) ?  &numberwidth : 0) -
    \ &foldcolumn -
    \ (len(signlist) > 2 ? 2 : 0)

  return winwidth(0) > 40 ?
    \ printf("C%d/%2d", p[2], width) :
    \ printf("C%d", p[2])
endfunction

"-----------------------------------------
" vim-indent-guides

let g:indent_guides_enable_on_vim_startup = 1 " vim起動時に有効にする
let g:indent_guides_guide_size = 1            " サイズは1文字で表現する

" nerdtree は除外する
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']

" 使い方
" <Leader>ig --> インデントガイドの有効無効を切り替える
" なお、<Leader> のデフォルトは \ キー

"-----------------------------------------
" vim-quickrun

" 使い方
" :QuickRun<enter> でバッファ内を実行すると結果が別バッファで得られる。
" Python 等のコードを書いて実行する等が便利。

"-----------------------------------------
" vim-slime

" 使い方
" $ tmux
" C-b :split-window         --> 画面が水平2分割される
" C-b q                     --> 画面の番号を確認
" vim
" idate<ESC>                --> 1行目に date を書く
" C-c C-c
" tmux socket name: default
" tmux target pane: :0.0    --> 初回はどの pane に出力するか決める
"                           --> date が実行される
" C-c C-c                   --> 2回目以降は pane 指定不要となる

"-----------------------------------------
" vim-surround

" Visualモードで範囲を選択して S + '記号' と入力すると、記号で括る
" vim
" iThis is a selected text.<ESC>
" /a<enter>
" v/t<enter>nn
" S"

"-----------------------------------------
" vim-fugitive

" コミットログを確認する
"   :Glog | copen
"     --> quickfix にログを表示
" キーワード検索する
"   :Ggrep 検索したいワード | copen
"     --> quickfix に検索結果を表示
" 編集箇所がどのコミットか確認する
"   :Gblame
" コミットするファイルを選ぶ
"   :Gstatus
"     --> 行選択して、 - で add/reset に。 p でパッチ表示。
" コミット予定の差分を確認する
"   :Git! diff --cached
"     --> git diff --cached
"   :Greview
" コミットする
"   :Gcommit
" プッシュする
"   :Gpush

"-----------------------------------------
" vim-snippets

" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" 使い方
" $ vim hoge.c
" main<tab>
"   --> main 関数のひな型作られる
" $ vim hoge.yml
" :set ft=ansible
" lineinfile<tab>

" 他にもスニペット管理があるが、
" ansible-vim のディレクトリ名にあわせて UltiSnips を選択した。

"-----------------------------------------
" ansible-vim

let g:ansible_unindent_after_newline = 1
let g:ansible_attribute_highlight = "ob"
let g:ansible_name_highlight = 'd'
let g:ansible_extra_keywords_highlight = 1
let g:ansible_normal_keywords_highlight = 'Constant'

" 初期設定:
" $ sudo yum install epel-release -y
" $ sudo yum-config-manager --disable epel
" $ sudo yum --enablerepo=epel install ansible -y
" $ cd ~/.vim/bundles/repos/github.com/pearofducks/ansible-vim/UltiSnips
" $ ./generate.py

" 使い方:
" $ mkdir -pv /tmp/playbooks
" $ vim /tmp/playbooks/hoge.yml
" i- name: hoge<enter>lineinfile<tab>
"   --> lineinfile の引数が列挙される

"-----------------------------------------
" vim-markdown

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0

"-----------------------------------------
" tagbar

let g:tagbar_type_ansible = {
  \   'ctagstype' : 'ansible',
  \   'kinds' : [ 't:tasks' ],
  \   'sort' : 0
  \ }

let g:tagbar_type_rst = {
  \   'ctagstype': 'rst',
  \   'ctagsbin' : '~/.vim/plugged/rst2ctags/rst2ctags.py',
  \   'ctagsargs' : '-f - --sort=yes',
  \   'kinds' : [ 's:sections', 'i:images' ],
  \   'sro' : '|',
  \   'kind2scope' : { 's' : 'section' },
  \   'sort': 0,
  \ }

let g:tagbar_type_ps1 = {
  \   'ctagstype': 'powershell',
  \   'kinds': [
  \     'f:function',
  \     'i:filter',
  \     'a:alias'
  \   ]
  \ }

let g:tagbar_type_markdown = {
  \   'ctagstype': 'markdown',
  \   'ctagsargs': '-f - --sort=yes',
  \   'kinds' : [
  \     's:sections',
  \     'i:images'
  \   ],
  \   'sro' : '|',
  \   'kind2scope' : {
  \     's' : 'section',
  \   },
  \   'sort': 0,
  \ }

"-----------------------------------------
" vim-flake8

let g:flake8_show_in_gutter=1

" 使い方:
" $ vim x.py
" F7
"   --> flake8 が実行され QuickFix に表示される

"-----------------------------------------

" ファイルタイプを定める

au BufRead,BufNewFile */playbooks/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */ansible/*.yml set filetype=yaml.ansible

au BufRead,BufNewFile */dot.gitconfig_local.inc set filetype=conf
au BufRead,BufNewFile */.gitconfig_local.inc set filetype=conf

au BufRead,BufNewFile *.md set filetype=markdown
