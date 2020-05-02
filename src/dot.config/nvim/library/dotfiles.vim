let g:OS_TYPE_UNKNOWN = 0
let g:OS_TYPE_WINDOWS = 'Windows'
let g:OS_TYPE_LINUX = 'Linux'
let g:OS_TYPE_MAC_OS = 'macOS'

let g:VIM_TYPE_NEOVIM = 'NeoVim'
let g:VIM_TYPE_VIM = 'Vim'

let g:GUI_TYPE_RUNNING = 'running'
let g:GUI_TYPE_NOT_RUNNING = 'not running'

let g:VIM_VERSION_UNKNOWN = 0
let g:VIM_VERSION_7 = 'version eq 7'
let g:VIM_VERSION_8 = 'version ge 8'

function! dotfiles#get_os_type()
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

function! dotfiles#get_vim_type()
  if has('nvim')
    return g:VIM_TYPE_NEOVIM
  endif
  return g:VIM_TYPE_VIM
endfunction

function! dotfiles#get_gui_type()
  if exists('g:ginit_loaded') || has('gui_running')
    return g:GUI_TYPE_RUNNING
  endif
  return g:GUI_TYPE_NOT_RUNNING
endfunction

function! dotfiles#get_vim_version()
  if v:version >= 800
    return g:VIM_VERSION_8
  endif
  if v:version >= 700
    return g:VIM_VERSION_7
  endif
  return g:VIM_VERSION_UNKNOWN
endfunction

function! dotfiles#get_enable_dev_icons()
  if dotfiles#get_vim_type() == g:VIM_TYPE_NEOVIM
    return 1
  endif
  if dotfiles#get_gui_type() == g:GUI_TYPE_RUNNING
    return 1
  endif
  return 0
endfunction

" 以下、削除予定
function! g:MyGetOsType()
  return dotfiles#get_os_type()
endfunction

function! g:MyGetVimType()
  return dotfiles#get_vim_type()
endfunction

function! g:MyGetGuiType()
  return dotfiles#get_gui_type()
endfunction

function! g:MyGetVimVersion()
  return dotfiles#get_vim_version()
endfunction
