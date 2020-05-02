" $HOME/.config/nvim/plugins.vim

runtime library/dotfiles.vim

" 実行環境を調べる
let g:my_os_type = dotfiles#get_os_type()
let g:my_vim_type = dotfiles#get_vim_type()
let g:my_gui_type = dotfiles#get_gui_type()
let g:my_vim_version = dotfiles#get_vim_version()

" 有効にする機能を決定する
let g:enable_devicons = dotfiles#get_enable_dev_icons()

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
  Plug 'junegunn/goyo.vim', { 'for': [
          \ 'markdown',
          \ 'rst',
          \ 'text',
        \ ] }

  " A dark, low-contrast, Vim colorscheme.
  Plug 'romainl/Apprentice'

  " Retro groove color scheme for Vim
  Plug 'morhetz/gruvbox'

  " EditorConfig Vim Plugin
  Plug 'editorconfig/editorconfig-vim'

  " *submode.txt* Create your own submodes
  Plug 'kana/vim-submode'

  " Vim plugin that displays tags in a window, ordered by scope
  Plug 'majutsushi/tagbar', { 'for': [
          \ 'go',
          \ 'markdown',
          \ 'python',
          \ 'rst',
          \ 'sh',
          \ 'snippets',
          \ 'vim',
        \ ] }

  " Generate ctags-compatible tags files for Markdown documents.
  Plug 'jszakmeister/markdown2ctags', { 'for': ['markdown'] }

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

  Plug 'kumarstack55/vim-snippets-local'

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
    Plug 'dense-analysis/ale', { 'for': ['python', 'sh'] }

    " ALE indicator for the lightline vim plugin
    Plug 'maximbaz/lightline-ale'
  endif

  " VimDevIcons - Add Icons to Your Plugins
  if g:enable_devicons
    Plug 'ryanoasis/vim-devicons'
  endif

  " (Do)cumentation (Ge)nerator 15+ languages
  Plug 'kkoomen/vim-doge'

  " Yet Another Lexima
  Plug 'mattn/vim-lexiv'

  " vim-coverage is a utility for visualizing test coverage results in vim.
  Plug 'google/vim-maktaba'
  Plug 'google/vim-coverage'
  Plug 'google/vim-glaive'
call plug#end()
