scriptencoding utf-8

" 設定用のファンクションを定義する。 {{{

" Windows の場合は runtimepath を加える。
if has('win32')
  set runtimepath+=~/.config/nvim
endif

runtime library/dotfiles.vim

" Windows + nvim では Python3 を使う
if has('win32') && has('nvim')
  let s:python_path_list = [
        \ 'C:\Python310\python.exe',
        \ 'C:\Python39\python.exe',
        \ 'C:\Python38\python.exe',
        \ 'C:\Python37\python.exe',
        \ 'C:\Python36\python.exe']
  for s:python_path in s:python_path_list
    if executable(s:python_path)
      let g:python3_host_prog = s:python_path
      break
    endif
  endfor
endif

" Windows + nvim では Python2 は使わない
if has('win32') && has('nvim')
  let g:loaded_python_provider = 0
endif

" Windows + vim では Python3 を使う
if has('win32') && !has('nvim')
  let s:python_dll_path_list = [
        \ 'C:\Python310\python310.dll',
        \ 'C:\Python39\python39.dll',
        \ 'C:\Python38\python38.dll',
        \ 'C:\Python37\python37.dll',
        \ 'C:\Python36\python36.dll']
  for s:python_dll_path in s:python_dll_path_list
    if filereadable(s:python_dll_path)
      let &pythonthreedll = s:python_dll_path
      break
    endif
  endfor
endif

" }}}
" プラグインを管理する。 {{{
call plug#begin('~/.vim/plugged')
  " vim-cheatsheet opens your cheat sheet file.
  Plug 'reireias/vim-cheatsheet', { 'on': 'Cheat' }

  " a universal set of defaults that (hopefully) everyone can agree on.
  Plug 'tpope/vim-sensible'

  " Vaffle is a lightweight file manager for Vim.
  Plug 'cocopon/vaffle.vim'

  " NERDTree
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

  " This adds syntax for nerdtree on most common file extensions.
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight',
        \ { 'on': 'NERDTreeToggle' }

  if !(has('win32') && !has('nvim') && !has('gui_running'))
    " iceberg.vim が依存するために導入する。
    " Pgmnt is a template engine for creating Vim color schemes.
    Plug 'cocopon/pgmnt.vim'

    " Iceberg is well-designed, bluish color scheme for Vim and Neovim.
    Plug 'cocopon/iceberg.vim'

    " Theme for various programs, designed with love for iceberg.vim theme.
    Plug 'gkeep/iceberg-dark'

    " lightline.vim - A light and configurable statusline/tabline
    " plugin for Vim
    Plug 'itchyny/lightline.vim'
  endif

  " EditorConfig Vim Plugin
  Plug 'editorconfig/editorconfig-vim'

  " Vim plugin that displays tags in a window, ordered by scope
  Plug 'majutsushi/tagbar', {
        \ 'for': [
          \ 'bats',
          \ 'c',
          \ 'go',
          \ 'markdown',
          \ 'ps1',
          \ 'python',
          \ 'rst',
          \ 'rust',
          \ 'sh',
          \ 'snippets',
          \ 'vim',
        \ ] }

  " ctrlp.vim - Full path fuzzy file, buffer, mru, tag, ...
  " finder for Vim.
  Plug 'ctrlpvim/ctrlp.vim'

  " BufExplorer Plugin for Vim
  Plug 'jlanzarotta/bufexplorer'

  " Indent Guides is a plugin for visually displaying indent levels in Vim.
  if v:version >= 800
    Plug 'nathanaelkane/vim-indent-guides'
  endif

  " quickrun.txt - Run a command and show its result quickly.
  Plug 'thinca/vim-quickrun'

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

  Plug 'kumarstack55/vim-snippets-local'

  " A vim plugin for syntax highlighting Ansible's common filetypes
  if has('linux') && executable("ansible")
    Plug 'pearofducks/ansible-vim', {
          \ 'for': 'yaml.ansible',
          \ 'do': './UltiSnips/generate.sh --style dictionary' }
  else
    Plug 'pearofducks/ansible-vim', { 'for': 'yaml.ansible' }
  endif

  if has('python3')
    " UltiSnips is the ultimate solution for snippets in Vim.
    Plug 'SirVer/ultisnips'
  elseif has('python')
    " ultisnips の Python2 サポートは 3.1 まで。
    " 3.2 以降は Python2 では動作しない。
    Plug 'SirVer/ultisnips', { 'tag': '3.1' }
  endif

  " vim-markdown を利用するために必要なプラグイン
  " vim-markdown より前である必要がある
  " Vim script for text filtering and alignment
  Plug 'godlygeek/tabular'

  " Syntax highlighting, matching rules and mappings
  " for the original Markdown and extensions.
  Plug 'plasticboy/vim-markdown', { 'for': ['md', 'text'] }

  " It provides nice syntax coloring and indenting
  " for Windows PowerShell (.ps1 files, and also includes
  " a filetype plugin so Vim can autodetect your PS1 scripts.
  Plug 'PProvost/vim-ps1', { 'for': ['ps1', 'psm', 'md'] }

  " Vim のプラグインではないが、git clone させるために加えている。
  " A simple script to help create ctags-compatible tag files
  " for the sections within a reStructuredText document.
  Plug 'jszakmeister/rst2ctags'

  " (Do)cumentation (Ge)nerator 15+ languages
  if has('nvim') || (v:version > 700 && has('patch-7.4.2119'))
    " Vim v7.4.2119+ is required.
    Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
  endif

  " Yet Another Lexima
  if has('nvim') || v:version >= 801
    " VIM 8.1 or above is required.
    Plug 'mattn/vim-lexiv'
  endif

  " Syntax files for Bats (Bash Automated Testing System).
  Plug 'aliou/bats.vim'

  if v:version >= 800
    " Async Language Server Protocol plugin for vim8 and neovim.
    Plug 'prabirshrestha/vim-lsp'

    " Auto configurations for Language Servers for vim-lsp.
    Plug 'mattn/vim-lsp-settings'

    " auto-completion を利用する場合、 asyncomplete か ddc を選ぶ。
    " ここでは asyncomplete を選ぶ。

    " Async autocompletion for Vim 8 and Neovim with |timers|.
    Plug 'prabirshrestha/asyncomplete.vim'

    " Provide Language Server Protocol autocompletion source for
    " asyncomplete.vim and vim-lsp.
    Plug 'prabirshrestha/asyncomplete-lsp.vim'

  endif

  if v:version >= 800
    " Check syntax in Vim asynchronously and fix files,
    " with Language Server Protocol (LSP) support
    Plug 'dense-analysis/ale', { 'for': ['sh'] }

    " ALE indicator for the lightline vim plugin
    Plug 'maximbaz/lightline-ale'
  endif

  if has("nvim") && v:version >= 801
    " fernのNoteの記述に従いnvimでは適用する
    " Fix CursorHold Performance
    if has("nvim")
      Plug 'antoinemadec/FixCursorHold.nvim'
    endif

    " General purpose asynchronous tree viewer written in Pure Vim script.
    Plug 'lambdalisue/fern.vim'

    " A plugin for fern.vim which provides simple bookmark feature.
    Plug 'lambdalisue/fern-bookmark.vim'
  endif

  " Signify (or just Sy) uses the sign column to indicate added, modified
  " and removed lines in a file that is managed by a version control
  " system (VCS).
  if has('nvim') || has('patch-8.0.902')
    Plug 'mhinz/vim-signify'
  else
    Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
  endif

  " Easy and high speed coding method.
  Plug 'mattn/vim-sonictemplate'

  " The extended search motion.
  "if has('nvim')
  "  Plug 'hrsh7th/vim-searchx'
  "endif
call plug#end()

" }}}
" コマンドを定義する。 {{{

" フォントサイズを設定する
if !has('nvim') && has('gui_running')
  call dotfiles#define_font_size_commands()
endif

" tabstop, shiftwidth を変える
command! MyTabstopWidth2 call s:set_tabstop(2)
command! MyTabstopWidth3 call s:set_tabstop(3)
command! MyTabstopWidth4 call s:set_tabstop(4)

" ファイルタイプ用の設定にする
function! s:indent_guide_disabled()
  call indent_guides#init_matches()
  return empty(w:indent_guides_matches)
endfunction

function! s:indent_guide_enabled()
  return ! s:indent_guide_disabled()
endfunction

function! s:indent_guide_reload()
  if s:indent_guide_enabled()
    IndentGuidesDisable
    IndentGuidesEnable
  endif
endfunction

function! s:set_tabstop(ts)
  let &l:tabstop = a:ts
  let &l:shiftwidth = a:ts
  let &l:softtabstop = a:ts
  setlocal expandtab
  call s:indent_guide_reload()
endfunction

function! s:set_filetype_markdown()
  setlocal filetype=markdown
  call s:set_tabstop(4)
endfunction

function! s:set_filetype_rst()
  setlocal filetype=rst
  call s:set_tabstop(3)
endfunction

function! s:set_filetype_ps1()
  setlocal filetype=ps1
  call s:set_tabstop(4)
endfunction

command! MyFiletypeMarkdown call s:set_filetype_markdown()
command! MyFiletypeRst call s:set_filetype_rst()
command! MyFiletypePowerShell call s:set_filetype_rst()

" カーソル行の直後にmodelineを加える
function! s:add_modeline()
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

command! MyModelineAppend call s:add_modeline()

" Tagbar を開きなおす。
function! s:tagbar_reopen()
  if exists('t:tagbar_buf_name') && bufwinnr(t:tagbar_buf_name) != -1
    TagbarClose
    TagbarOpen
  endif
endfunction

command! MyTagbarReopen call s:tagbar_reopen()

" Tagbar の表示を左と右で切り替える。
function! s:tagbar_position_switch_left_right()
  let pos_left = 'topleft vertical'
  let pos_right = 'botright vertical'
  if exists("g:tagbar_position") && g:tagbar_position == pos_left
    let g:tagbar_position = pos_right
    call s:tagbar_reopen()
  elseif exists("g:tagbar_position") && g:tagbar_position == pos_right
    let g:tagbar_position = pos_left
    call s:tagbar_reopen()
  endif
endfunction

command! MyTagbarPositionSwitchLeftRight
  \ call s:tagbar_position_switch_left_right()

" }}}
" クリップボードを設定する。 {{{

if has('win32') && !has('nvim') && has('gui_running')
  " 選択範囲をシステムのクリップボードにコピーする。
  set guioptions+=a
endif

if has('clipboard')
  set clipboard&

  " すべてのヤンクをクリップボードに登録する。
  if has('nvim') || has('unnamedplus')
    set clipboard^=unnamedplus
  else
    set clipboard^=unnamed
  endif

  " 選択範囲をクリップボードに登録する。
  if (has('win32unix') && !has('nvim')) || (has('win32') && !has('nvim'))
    set clipboard^=autoselect
  endif
endif

" }}}
" ツールバーを設定する。 {{{

if !has('nvim') && has('gui_running')
  " Gvim でツールバーを非表示にする。
  set guioptions-=T
endif

if has('win32') && !has('nvim') && has('gui_running')
  " GVim で encoding=utf8 かつメニューを日本語で表示させると、
  " 表示がおかしくなるため、英語表示とする。
  set langmenu=en_US
  source $VIMRUNTIME/delmenu.vim
  source $VIMRUNTIME/menu.vim
endif

" }}}
" マウス操作を設定する。 {{{

"	Normal, Visual, Insert, Command-line モードでマウスを有効にする。
"	ただし、gVim 以外ではターミナル機能の文字列選択を利用したいので設定しない。
if has('win32') && !has('nvim') && has('gui_running')
  if has('mouse')
    set mouse=a
  endif
endif

" Visual や Select モードで、
" 選択開始時に1文字選択した状態とする。
" また、行末1文字先を選択できるようにして、行選択時に改行も選択範囲とする。
set selection=inclusive

" 右クリックは xterm のように選択範囲を拡張する。
set mousemodel=extend

" }}}
" エンコーディングを設定する。 {{{

" vim内で使うエンコーディングを指定する。
" ヘルプより、強く推奨されている。
" > NOTE: For GTK+ 2 or later, it is highly recommended to set 'encoding'
" > to "utf-8".
set encoding=utf8

" }}}
" 文字表示を設定する。 {{{

" 絵文字などの表示を期待通りにするために、
" East Asian Width Class Ambiguous を2文字幅で扱う
set ambiwidth=double

" }}}
" ベルを設定する。 {{{

" ベルを無効にする。音声会議でノイズを発生させないようにしたいため。
set belloff=all
set noerrorbells

" ビジュアルベルを鳴らさない。画面を見てもらうときにフラッシュを避けたいため。
set t_vb=
set novisualbell

" }}}
" フォント、カラースキームを設定する。 {{{

if !has('nvim') && has('gui_running')
  " フォントサイズを設定する。
  " この設定を有効にすることで、プリント時の文字化けが回避された。
  MyFontSizeNormal
endif

" カラースキームを設定する。
if !(has('win32') && !has('nvim') && !has('gui_running'))
  colorscheme iceberg
endif

" }}}
" 検索時のステータス表示を設定する。 {{{

" 検索時に [1/5] のようなサーチカウントを表示する。 例: [1/5]
if has('patch 8.1.1270')
  set shortmess-=S
endif

" }}}
" ウィンドウ分割、プレビューウィンドウを設定する。 {{{

" split,close時、ウィンドウの自動リサイズを行わない。
set noequalalways

" 置換時に置換結果のプレビューをプレビューウィンドウで表示する。
if has('nvim')
  set inccommand=split
endif

" ウィンドウを <C-w>+<C-w>+ の代わりに <C-w>++ でサイズ変更する。
" https://zenn.dev/mattn/articles/83c2d4c7645faa
nmap <C-w>+ <C-w>+<SID>ws
nmap <C-w>- <C-w>-<SID>ws
nmap <C-w>> <C-w>><SID>ws
nmap <C-w>< <C-w><<SID>ws
nnoremap <script> <SID>ws+ <C-w>+<SID>ws
nnoremap <script> <SID>ws- <C-w>-<SID>ws
nnoremap <script> <SID>ws> <C-w>><SID>ws
nnoremap <script> <SID>ws< <C-w><<SID>ws
nmap <SID>ws <Nop>

" }}}
" ウィンドウを設定する。 {{{

" 行番号を表示させない。
set nonumber

if has('gui_running')
  " insert モードで IM を OFF にする。
  set iminsert=0

  " 検索パタンを入力時、 IM を iminsert 設定値で設定する。
  set imsearch=-1
endif

" 検索キーワードを強調させない。
set nohlsearch

" カーソルの上下端で表示するスクリーン行数の最小数を指定する
set scrolloff=5

" 折り畳み行の行頭に視覚的なインデントを入れる
if v:version > 704
  set breakindent
endif

" カーソル行を表示させる。
" ただし、Windows + Vim は見た目がひどいため、表示させない。
if !(has('win32') && !has('nvim') && !has('gui_running'))
  set cursorline
endif

" neovide のときカーソル移動のアニメーションを設定する。
let g:neovide_cursor_vfx_mode = "railgun"

" 長い行を入力するときvimが改行を入れないようにする
set textwidth=0

" 80文字目に色をつける
" ただし、Windows + Vim は見た目がひどいため、表示させない。
if !(has('win32') && !has('nvim') && !has('gui_running'))
  if exists('+colorcolumn')
    set colorcolumn=80
  endif
endif

" }}}
" カーソルの移動を設定する。 {{{

" gjgj の代わりに gjj、同様に gkk で視覚的な行の上下を移動できるようにする。
" https://zenn.dev/mattn/articles/83c2d4c7645faa
nmap gj gj<SID>g
nmap gk gk<SID>g
nnoremap <script> <SID>gj gj<SID>g
nnoremap <script> <SID>gk gk<SID>g
nmap <SID>g <Nop>

" }}}
" ファイル編集の設定をする。 {{{

" バックアップファイル (*~) を作らない
set nobackup

" 同ファイルの複数編集に気づけるようスワップファイルを作る
set swapfile

" Windows環境では次のパスにスワップを作る
if has('win32')
  set directory=$TEMP,c:\\tmp,c:\\temp,.
endif

" undo ファイル (un~) を作らない
set noundofile

" 既存ファイル編集時のエンコーディング候補順序を定める
set fileencodings=utf-8,cp932,utf-16le

" modelineの認識は先頭と末尾の行数を指定する
set modelines=5

" インデントするとき shiftwidth の整数倍にする。
set shiftround

" ファイル再オープン時にカーソルを移動する
" (:help restore-cursor)
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" }}}
" ファイルの種類ごとの設定をする。 {{{

augroup vimrc
  autocmd!

  autocmd FileType yaml
    \ setlocal indentexpr=""

  autocmd BufRead,BufNewFile */playbooks/*.yml
    \ setlocal filetype=yaml.ansible
  autocmd BufRead,BufNewFile */ansible/*.yml
    \ setlocal filetype=yaml.ansible
  autocmd FileType yaml.ansible
    \ setlocal indentexpr=""

  autocmd BufRead,BufNewFile */dot.gitconfig_local.inc
    \ setlocal filetype=conf
  autocmd BufRead,BufNewFile */.gitconfig_local.inc
    \ setlocal filetype=conf

  autocmd FileType markdown
    \ setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab

  autocmd FileType ps1
    \ setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab colorcolumn=140

  " vim-sonictemplate
  autocmd BufRead,BufNewFile *.stpl
    \ setlocal list listchars=tab:>-

augroup END

" }}}
" lightline を設定する。 {{{

set laststatus=2 " 常にステータスを表示させる
let g:lightline = {}
let g:lightline.colorscheme =  'icebergDark'
let g:lightline.separator = { 'left': '' }
let g:lightline.subseparator = { 'left': '|', 'right': '|' }
let g:lightline.active = {}
let g:lightline.active.left = [
    \ [ 'paste' ],
    \ [ 'fugitive', 'filename' ]
  \ ]
let g:lightline.active.right = [
    \ ['filetype', 'fileencoding', 'fileformat'],
    \ ['percent'],
    \ ['lineinfo']
  \ ]
let g:lightline.component_function = {
    \ 'fileformat': 'LightLineFileformat',
    \ 'filename': 'LightLineFilename',
    \ 'filetype': 'LightLineFiletype',
    \ 'fugitive': 'LightLineFugitive',
    \ 'lineinfo': 'LightLineLineColumnInfo',
    \ 'modified': 'LightLineModified',
    \ 'percent': 'LightLinePercent',
    \ 'readonly': 'LightLineReadonly',
  \ }
if v:version >= 800
  let g:lightline.component_expand = {
      \ 'linter_checking': 'lightline#ale#checking',
      \ 'linter_warnings': 'lightline#ale#warnings',
      \ 'linter_errors': 'lightline#ale#errors',
      \ 'linter_ok': 'lightline#ale#ok',
    \ }
  let g:lightline.component_type = {
      \ 'linter_checking': 'left',
      \ 'linter_warnings': 'warning',
      \ 'linter_errors': 'error',
      \ 'linter_ok': 'left',
    \ }
  call insert(g:lightline.active.right[0], 'linter_ok', 0)
  call insert(g:lightline.active.right[0], 'linter_warnings', 0)
  call insert(g:lightline.active.right[0], 'linter_errors', 0)
  call insert(g:lightline.active.right[0], 'linter_checking', 0)
endif

function! LightLinePercent()
  return printf('L%d/%d:%3d%%',
        \ line('.'), line('$'), line('.')*100/line('$'))
endfunction

function! LightLineFugitive()
  if exists("*fugitive#head")
    let _ = FugitiveHead()
    return strlen(_) ? _ : ''
  endif
  return ''
endfunction

function! LightLineReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return "[RO]"
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
    \ winwidth(0) > 70 ? ( strlen(&filetype) ? &filetype : 'no ft' ) : ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineLineColumnInfo()
  " カーソル位置を得る
  let p = getpos(".")

  " ウィンドウの幅を得る
  " https://stackoverflow.com/questions/26315925/
  if v:version >= 800
    let signs = execute(printf('sign place buffer=%d', bufnr('')))
  else
    redir =>signs |exe "sil sign place buffer=".bufnr('')|redir end
  endif
  let signlist = split(signs, '\n')
  let signwidth = len(signlist) >= 2 ? 2 : 0

  let lineno_cols = max([&numberwidth, strlen(line('$')) + 1])
  let width = winwidth(0)
    \ - signwidth
    \ - &foldcolumn
    \ - ((&number || &relativenumber) ? lineno_cols : 0)

  return winwidth(0) > 40 ?
    \ printf("C%d/%2d", p[2], width) :
    \ printf("C%d", p[2])
endfunction

" }}}
" プラグインごとの設定をする。 {{{

" ~/.config/nvim/_config/*.vim 等を読み込む
" 各 *.vim で次のようにするとロード済みのプラグインなら設定される。
"   if empty(globpath(&runtimepath, 'autoload/nerdtree.vim'))
"     finish
"   endif
" vim-plug で on, for など遅延ロードをする場合、
" 起動時に読まれないので注意すること。
for s:val in sort(split(globpath(&runtimepath, '_config/*.vim')))
  execute('exec "so" s:val')
endfor

" vim:foldmethod=marker:
