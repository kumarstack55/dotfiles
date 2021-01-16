" $HOME/.config/nvim/plugins.vim

if has('windows')
  set rtp+=~/.config/nvim
endif
runtime library/dotfiles.vim

" 初期状態として有効にするか決定する
" ターミナルの表示が崩れる等の場合は無効にすればよい
let g:enable_devicons = dotfiles#get_enable_dev_icons()

" Windows + nvim では Python3 を使う
if dotfiles#is_windows() && dotfiles#is_neovim()
  let g:loaded_python_provider = 0
  let g:python38_path = 'C:\Python38\python.exe'
  let g:python36_path = 'C:\Python36\python.exe'
  if executable(g:python38_path)
    let g:python3_host_prog = g:python38_path
  elseif executable(g:python36_path)
    let g:python3_host_prog = g:python36_path
  endif
  " Python2 は使わない
  let g:loaded_python_provider = 0
endif

" Windows + vim では Python3 を使う
if dotfiles#is_windows() && dotfiles#is_vim()
  let g:python36dll_path = 'C:\Python36\python36.dll'
  let g:python38dll_path = 'C:\Python38\python38.dll'
  if executable(g:python38dll_path)
    let &pythonthreedll=g:python38dll_path
  elseif filereadable(g:python36dll_path)
    let &pythonthreedll=g:python36dll_path
  endif
endif

" プラグインをインストールする
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

  " A dark, low-contrast, Vim colorscheme.
  Plug 'romainl/Apprentice'

  " Retro groove color scheme for Vim
  Plug 'morhetz/gruvbox'

  " Pgmnt is a template engine for creating Vim color schemes.
  Plug 'cocopon/pgmnt.vim'

  " Iceberg is well-designed, bluish color scheme for Vim and Neovim.
  Plug 'kumarstack55/iceberg.vim'

  " EditorConfig Vim Plugin
  Plug 'editorconfig/editorconfig-vim'

  " *submode.txt* Create your own submodes
  Plug 'kana/vim-submode'

  " Vim plugin that displays tags in a window, ordered by scope
  Plug 'majutsushi/tagbar', { 'for': [
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

  if !dotfiles#has_mdctags()
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

  " Indent Guides is a plugin for visually displaying indent
  " levels in Vim.
  if dotfiles#get_vim_version() == g:VIM_VERSION_8
    Plug 'nathanaelkane/vim-indent-guides'
  endif

  " quickrun.txt - Run a command and show its result quickly.
  Plug 'thinca/vim-quickrun'

  " A vim plugin to give you some slime.
  if dotfiles#is_linux()
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
          \ 'do': 'which ansible && ./UltiSnips/generate.sh --style dictionary'
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
  Plug 'PProvost/vim-ps1', { 'for': ['ps1', 'psm', 'md'] }

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

  if dotfiles#version_ge_8()
    " Check syntax in Vim asynchronously and fix files,
    " with Language Server Protocol (LSP) support
    Plug 'dense-analysis/ale', { 'for': ['python', 'sh'] }

    " ALE indicator for the lightline vim plugin
    Plug 'maximbaz/lightline-ale'
  endif

  " VimDevIcons - Add Icons to Your Plugins
  if dotfiles#get_enable_dev_icons()
    Plug 'ryanoasis/vim-devicons'
  endif

  " (Do)cumentation (Ge)nerator 15+ languages
  if has('nvim') || (v:version > 700 && has('patch-7.4.2119'))
    " Vim v7.4.2119+ is required.
    Plug 'kkoomen/vim-doge'
  endif

  " Yet Another Lexima
  Plug 'mattn/vim-lexiv'

  " vim-coverage is a utility for visualizing test coverage results in vim.
  Plug 'google/vim-maktaba'
  Plug 'google/vim-coverage'
  Plug 'google/vim-glaive'

  " A simple Vimscript test framework
  Plug 'junegunn/vader.vim'

  " Syntax files for Bats (Bash Automated Testing System).
  "Plug 'aliou/bats.vim'
  Plug 'kumarstack55/bats.vim'

  if dotfiles#version_ge_8()
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

  if has('nvim') || has('patch-8.0.902')
    Plug 'mhinz/vim-signify'
  else
    Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
  endif
call plug#end()
