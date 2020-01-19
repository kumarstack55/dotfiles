" $HOME/.config/nvim/plugins.vim

" OSを判定する
let g:OS_TYPE_UNKNOWN = 0
let g:OS_TYPE_WINDOWS = 'Windows'
let g:OS_TYPE_LINUX = 'Linux'
let g:OS_TYPE_MAC_OS = 'macOS'
function! g:MyGetOsType()
  if has('win32')
    return g:OS_TYPE_WINDOWS
  endif
  let uname = substitute(system('uname'), '\n', '', '')
  if uname == 'Linux'
    return g:OS_TYPE_LINUX
  elseif uname == 'Darwin'
    return g:OS_TYPE_MAC_OS
  endif
  return g:OS_TYPE_UNKNOWN
endfunction
let g:my_os_type = g:MyGetOsType()

" vim, neovimを判定する
let g:VIM_TYPE_NEOVIM = 'NeoVim'
let g:VIM_TYPE_VIM = 'Vim'
function! g:MyGetVimType()
  if has('nvim')
    return g:VIM_TYPE_NEOVIM
  endif
  return g:VIM_TYPE_VIM
endfunction
let g:my_vim_type = g:MyGetVimType()

" GUI/CLIを判定する
let g:GUI_TYPE_RUNNING = 'running'
let g:GUI_TYPE_NOT_RUNNING = 'not running'
function! g:MyGetGuiType()
  if exists('g:ginit_loaded') || has('gui_running')
    return g:GUI_TYPE_RUNNING
  endif
  return g:GUI_TYPE_NOT_RUNNING
endfunction
let g:my_gui_type = g:MyGetGuiType()

" vim のバージョンを判定する
let g:VIM_VERSION_UNKNOWN = 0
let g:VIM_VERSION_7 = 'version eq 7'
let g:VIM_VERSION_8 = 'version ge 8'
function! g:MyGetVimVersion()
  if v:version >= 800
    return g:VIM_VERSION_8
  endif
  if v:version >= 700
    return g:VIM_VERSION_7
  endif
  return g:VIM_VERSION_UNKNOWN
endfunction
let g:my_vim_version = g:MyGetVimVersion()

" 有効にする機能を決定する
function! g:MyGetEnableDevIcons()
  if g:my_vim_type == g:VIM_TYPE_NEOVIM
    return 1
  endif
  if g:my_gui_type == g:GUI_TYPE_RUNNING
    return 1
  endif
  return 0
endfunction
let g:enable_devicons = g:MyGetEnableDevIcons()

" Python36 を読む
if g:my_os_type == g:OS_TYPE_WINDOWS
  if g:my_vim_type == g:VIM_TYPE_NEOVIM
    let g:loaded_python_provider = 0
    let g:python3_path = 'C:\Python36\python.exe'
    if executable(g:python3_path)
      let g:python3_host_prog = g:python3_path
    endif
  endif
  if g:my_vim_type == g:VIM_TYPE_VIM
    set pythonthreedll=C:\Python36\python36.dll
  endif
endif

" Python2 は読まない
if g:my_os_type == g:OS_TYPE_WINDOWS && g:my_vim_type == g:VIM_TYPE_NEOVIM
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
  Plug 'majutsushi/tagbar',
        \ { 'for': ['markdown', 'python', 'rst', 'go'] }

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
  if g:my_os_type == g:OS_TYPE_LINUX
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
        \ {
          \ 'for': 'yaml.ansible',
          \ 'do': 'which ansible && ./UltiSnips/generate.sh'
        \ }

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
  Plug 'PProvost/vim-ps1', { 'for': ['ps1', 'psm'] }

  " A simple script to help create ctags-compatible tag files
  " for the sections within a reStructuredText document.
  Plug 'jszakmeister/rst2ctags'

  " Flake8 plugin for Vim
  Plug 'nvie/vim-flake8', { 'for': 'python' }

  if has('python3')
    " UltiSnips is the ultimate solution for snippets in Vim.
    Plug 'SirVer/ultisnips'
  elseif has('python')
    " ultisnips の Python2 サポートは 3.1 まで。
    " 3.2 以降は Python2 では動作しない。
    Plug 'SirVer/ultisnips', { 'tag': '3.1' }
  endif

  if g:my_vim_version == g:VIM_VERSION_8
    " Check syntax in Vim asynchronously and fix files,
    " with Language Server Protocol (LSP) support
    Plug 'dense-analysis/ale'

    " ALE indicator for the lightline vim plugin
    Plug 'maximbaz/lightline-ale'
  endif

  " VimDevIcons - Add Icons to Your Plugins
  if g:enable_devicons
    Plug 'ryanoasis/vim-devicons'
  endif

call plug#end()
