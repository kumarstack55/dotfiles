scriptencoding utf-8

" 設定用のファンクションを定義する。 {{{

function! s:get_enable_dev_icons()
  return has('nvim') || has('gui_running')
endfunction

if has('windows')
  set runtimepath+=~/.config/nvim
endif
" runtime library/dotfiles.vim

" Windows + nvim では Python3 を使う
if has('win32') && has('nvim')
  let g:python39_path = 'C:\Python39\python.exe'
  let g:python38_path = 'C:\Python38\python.exe'
  let g:python36_path = 'C:\Python36\python.exe'
  if executable(g:python39_path)
    let g:python3_host_prog = g:python39_path
  elseif executable(g:python38_path)
    let g:python3_host_prog = g:python38_path
  elseif executable(g:python36_path)
    let g:python3_host_prog = g:python36_path
  endif
endif

" Windows + nvim では Python2 は使わない
if has('win32') && has('nvim')
  let g:loaded_python_provider = 0
endif

" Windows + vim では Python3 を使う
if has('win32') && !has('nvim')
  let g:python39dll_path = 'C:\Python39\python39.dll'
  let g:python38dll_path = 'C:\Python38\python38.dll'
  let g:python36dll_path = 'C:\Python36\python36.dll'
  if executable(g:python39dll_path)
    let &pythonthreedll=g:python39dll_path
  elseif executable(g:python38dll_path)
    let &pythonthreedll=g:python38dll_path
  elseif filereadable(g:python36dll_path)
    let &pythonthreedll=g:python36dll_path
  endif
endif

" 初期状態として有効にするか決定する。
" ターミナルの表示が崩れる等の場合は無効にすればよい。
let g:enable_devicons = s:get_enable_dev_icons()

" }}}
" プラグインを管理する。 {{{
call plug#begin('~/.vim/plugged')
  " vim-cheatsheet opens your cheat sheet file.
  Plug 'reireias/vim-cheatsheet', { 'on': 'Cheat' }

  " a universal set of defaults that (hopefully)
  " everyone can agree on.
  Plug 'tpope/vim-sensible'

  " NERDTree
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

  " This adds syntax for nerdtree on most common file extensions.
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight',
        \ { 'on': 'NERDTreeToggle' }

  " Pgmnt is a template engine for creating Vim color schemes.
  Plug 'cocopon/pgmnt.vim'

  " Iceberg is well-designed, bluish color scheme for Vim and Neovim.
  Plug 'cocopon/iceberg.vim'

  " Theme for various programs, designed with love for iceberg.vim theme.
  Plug 'gkeep/iceberg-dark'

  " EditorConfig Vim Plugin
  Plug 'editorconfig/editorconfig-vim'

  " *submode.txt* Create your own submodes
  Plug 'kana/vim-submode'

  " Vim plugin that displays tags in a window, ordered by scope
  Plug 'majutsushi/tagbar', {
        \ 'for': [
          \ 'bats',
          \ 'c',
          \ 'go',
          \ 'markdown',
          \ 'python',
          \ 'rst',
          \ 'rust',
          \ 'sh',
          \ 'snippets',
          \ 'vim',
        \ ] }

  if !executable('mdctags')
    " Generate ctags-compatible tags files for Markdown documents.
    Plug 'jszakmeister/markdown2ctags', { 'for': ['markdown'] }
  endif

  " vimfiler - A powerful file explorer implemented in Vim script
  Plug 'Shougo/vimfiler.vim'
  Plug 'Shougo/unite.vim'

  " ctrlp.vim - Full path fuzzy file, buffer, mru, tag, ...
  " finder for Vim.
  Plug 'ctrlpvim/ctrlp.vim'

  " BufExplorer Plugin for Vim
  Plug 'jlanzarotta/bufexplorer'

  " lightline.vim - A light and configurable statusline/tabline
  " plugin for Vim
  Plug 'itchyny/lightline.vim'

  " Indent Guides is a plugin for visually displaying indent levels in Vim.
  if v:version >= 800
    Plug 'nathanaelkane/vim-indent-guides'
  endif

  " quickrun.txt - Run a command and show its result quickly.
  Plug 'thinca/vim-quickrun'

  " A vim plugin to give you some slime.
  if has('unix')
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

  Plug 'kumarstack55/vim-snippets-local'

  " A vim plugin for syntax highlighting Ansible's common filetypes
  if !has('win32') && executable("ansible")
    Plug 'pearofducks/ansible-vim', { 'for': 'yaml.ansible',
          \ 'do': './UltiSnips/generate.sh --style dictionary' }
  else
    Plug 'pearofducks/ansible-vim', { 'for': 'yaml.ansible' }
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

  " A simple script to help create ctags-compatible tag files
  " for the sections within a reStructuredText document.
  Plug 'jszakmeister/rst2ctags'

  " Flake8 plugin for Vim
  "Plug 'nvie/vim-flake8', { 'for': 'python' }

  if has('python3')
    " UltiSnips is the ultimate solution for snippets in Vim.
    Plug 'SirVer/ultisnips'
  elseif has('python')
    " ultisnips の Python2 サポートは 3.1 まで。
    " 3.2 以降は Python2 では動作しない。
    Plug 'SirVer/ultisnips', { 'tag': '3.1' }
  endif

  if v:version >= 800
    " Check syntax in Vim asynchronously and fix files,
    " with Language Server Protocol (LSP) support
    "Plug 'dense-analysis/ale', { 'for': ['python', 'sh'] }

    " ALE indicator for the lightline vim plugin
    "Plug 'maximbaz/lightline-ale'
  endif

  " VimDevIcons - Add Icons to Your Plugins
  if g:enable_devicons
    Plug 'ryanoasis/vim-devicons'
  endif

  " (Do)cumentation (Ge)nerator 15+ languages
  if has('nvim') || (v:version > 700 && has('patch-7.4.2119'))
    " Vim v7.4.2119+ is required.
    Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
  endif

  " Yet Another Lexima
  Plug 'mattn/vim-lexiv'

  " vim-coverage is a utility for visualizing test coverage results in vim.
  "if !has('win32')
  "  Plug 'google/vim-maktaba'
  "  Plug 'google/vim-coverage'
  "  Plug 'google/vim-glaive'
  "endif

  " A simple Vimscript test framework
  "Plug 'junegunn/vader.vim'

  " Syntax files for Bats (Bash Automated Testing System).
  "Plug 'aliou/bats.vim'
  Plug 'kumarstack55/bats.vim'

  if v:version >= 800
    " normalize async job control api for vim and neovim
    Plug 'prabirshrestha/async.vim'

    " Async autocompletion for Vim 8 and Neovim with |timers|.
    Plug 'prabirshrestha/asyncomplete.vim'

    " Async Language Server Protocol plugin for vim8 and neovim.
    Plug 'prabirshrestha/vim-lsp'

    " Provide Language Server Protocol autocompletion source for
    " asyncomplete.vim and vim-lsp.
    Plug 'prabirshrestha/asyncomplete-lsp.vim'

    " Auto configurations for Language Servers for vim-lsp.
    Plug 'mattn/vim-lsp-settings'
  endif

  " fernのNoteの記述に従いnvimでは適用する
  " Fix CursorHold Performance
  if has("nvim")
    Plug 'antoinemadec/FixCursorHold.nvim'
  endif

  if has("nvim") || v:version >= 801
    " General purpose asynchronous tree viewer written in Pure Vim script.
    Plug 'lambdalisue/fern.vim'

    " A plugin for fern.vim which provides simple bookmark feature.
    Plug 'lambdalisue/fern-bookmark.vim'

    " A simplified version of vim-devicons which does NOT provide any 3rd
    " party integrations in itself. In otherwords, it is a fundemental
    " plugin to handle Nerd Fonts from Vim.
    Plug 'lambdalisue/nerdfont.vim'

    " fern.vim plugin which add file type icons through
    " lambdalisue/nerdfont.vim.
    Plug 'lambdalisue/fern-renderer-nerdfont.vim'
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
call plug#end()

" }}}
" コマンドを定義する。 {{{

" フォントサイズを設定する
if exists('g:ginit_loaded') || has('gui_running')
  function! s:set_gui_font(font_height_pt)
    let font_name = 'Cica'
    let height = 'h' . a:font_height_pt
    let options = [font_name, height]
    if has('win32') && !has('nvim')
      let charset = 'cSHIFTJIS'
      call add(options, charset)
      let quality = 'qDRAFT'
      call add(options, quality)
    endif
    let guifont_string = join(options, ':')
    let &guifont = guifont_string
  endfunction

  let s:FONT_SIZE_EXSMALL = 8
  let s:FONT_SIZE_SMALL = 10
  let s:FONT_SIZE_NORMAL = 12
  let s:FONT_SIZE_LARGE = 16
  let s:FONT_SIZE_EXLARGE = 20
  let s:FONT_SIZE_DEFAULT = s:FONT_SIZE_NORMAL

  command! MyFontSizeExSmall call s:set_gui_font(s:FONT_SIZE_EXSMALL)
  command! MyFontSizeSmall call s:set_gui_font(s:FONT_SIZE_SMALL)
  command! MyFontSizeNormal call s:set_gui_font(s:FONT_SIZE_NORMAL)
  command! MyFontSizeLarge call s:set_gui_font(s:FONT_SIZE_LARGE)
  command! MyFontSizeExLarge call s:set_gui_font(s:FONT_SIZE_EXLARGE)
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

command! MyFiletypeMarkdown call s:set_filetype_markdown()
command! MyFiletypeRst call s:set_filetype_rst()

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

" Tagbar をリロードする
function! s:tagbar_reload()
  if exists('t:tagbar_buf_name') && bufwinnr(t:tagbar_buf_name) != -1
    TagbarClose
    TagbarOpen
  endif
endfunction

command! MyTagbarReload call s:tagbar_reload()

" }}}
" クリップボードを設定する。 {{{

if exists('g:ginit_loaded') || has('gui_running')
  " 選択範囲をシステムのクリップボードにコピーする。
  set guioptions+=a
endif

" }}}
" ツールバーを設定する。 {{{

if exists('g:ginit_loaded') || has('gui_running')
  " ツールバーを非表示にする。
  set guioptions-=T
endif

" }}}
" マウス操作を設定する。 {{{

if exists('g:ginit_loaded') || has('gui_running')
  "	Normal, Visual, Insert, Command-line モードでマウスを有効にする。
  set mouse=a
endif

" Visual や Select モードで、
" 選択開始時に1文字選択した状態とする。
" また、行末1文字先を選択できるようにして、行選択時に改行も選択範囲とする。
set selection=inclusive

" 右クリックは xterm のように選択範囲を拡張する。
set mousemodel=extend

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

if exists('g:ginit_loaded') || has('gui_running')
  " フォントサイズを設定する。
  " この設定を有効にすることで、プリント時の文字化けが回避された。
  MyFontSizeNormal
endif

" カラースキームを設定する。
colorscheme iceberg

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

" }}}
" ウィンドウを設定する。 {{{

" 行番号を表示させない。
set nonumber

if exists('g:ginit_loaded') || has('gui_running')
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

" カーソル行を表示させる
set cursorline

" 長い行を入力するときvimが改行を入れないようにする
set textwidth=0

" 80文字目に色をつける
if exists('+colorcolumn')
  set colorcolumn=80
endif

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

  " vim-sonictemplate
  autocmd BufRead,BufNewFile *.stpl
    \ setlocal list listchars=tab:>-

augroup END

" }}}
" プラグイン間で利用するファンクションを定義する。 {{{

function! s:devicons_enable()
  let g:enable_devicons = 1
  let g:lightline#ale#indicator_checking = "\uf110"
  let g:lightline#ale#indicator_warnings = "\uf071"
  let g:lightline#ale#indicator_errors = "\uf05e"
  let g:lightline#ale#indicator_ok = "\uf00c"
endfunction

function! s:devicons_disable()
  let g:enable_devicons = 0
  let g:lightline#ale#indicator_warnings = 'W: '
  let g:lightline#ale#indicator_errors = 'E: '
  let g:lightline#ale#indicator_ok = 'OK'
  let g:lightline#ale#indicator_checking = 'Linting...'
endfunction

function! s:devicons_toggle()
  if g:enable_devicons
    call s:devicons_disable()
  else
    call s:devicons_enable()
  endif
endfunction

command! MyDevIconsEnable call s:devicons_enable()
command! MyDevIconsDisable call s:devicons_disable()
command! MyDevIconsToggle call s:devicons_toggle()

" }}}
" vim-devicons を設定する。 {{{

" vim内で使うエンコーディングを指定する
set encoding=utf8

" East Asian Width Class Ambiguous を2文字幅で扱う
set ambiwidth=double

if g:enable_devicons
  if has('win32') && (exists('g:ginit_loaded') || has('gui_running'))
    " gvim で encoding=utf8 かつメニューを日本語で表示させると、
    " 表示がおかしくなるため、英語表示とする。
    set langmenu=en_US
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
  endif

  " フォルダアイコンの表示をON
  let g:WebDevIconsUnicodeDecorateFolderNodes = 1
endif

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
  if g:enable_devicons
    call s:devicons_enable()
  else
    call s:devicons_disable()
  endif
endif

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
    "return g:enable_devicons ? "" : "[RO]"
    return g:enable_devicons ? "[RO]" : "[RO]"
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
      \ strlen(&filetype) ?
        \ &filetype . (
          \ g:enable_devicons ?
            \ ' ' . WebDevIconsGetFileTypeSymbol() : ''
        \ ) : 'no ft'
      \ ) :
      \ strlen(&filetype) ? (
        \ g:enable_devicons ?
          \ WebDevIconsGetFileTypeSymbol() : ''
      \ ) : ''
endfunction

function! LightLineFileformat()
  return
    \ winwidth(0) > 70 ? (
      \ &fileformat . (
          \ g:enable_devicons ?
          \ ' ' . WebDevIconsGetFileFormatSymbol()
          \ : ''
        \ )
      \ ) :
      \ (g:enable_devicons ? WebDevIconsGetFileFormatSymbol() : '')
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
