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

let g:FONT_SIZE_SMALL = 10
let g:FONT_SIZE_NORMAL = 12
let g:FONT_SIZE_LARGE = 16
let g:FONT_SIZE_EXLARGE = 20
let g:FONT_SIZE_DEFAULT = g:FONT_SIZE_NORMAL

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

function! dotfiles#is_linux()
  return dotfiles#get_os_type() == g:OS_TYPE_LINUX
endfunction

function! dotfiles#is_windows()
  return dotfiles#get_os_type() == g:OS_TYPE_WINDOWS
endfunction

function! dotfiles#get_vim_type()
  if has('nvim')
    return g:VIM_TYPE_NEOVIM
  endif
  return g:VIM_TYPE_VIM
endfunction

function! dotfiles#is_neovim()
  return dotfiles#get_vim_type() == g:VIM_TYPE_NEOVIM
endfunction

function! dotfiles#is_vim()
  return dotfiles#get_vim_type() == g:VIM_TYPE_VIM
endfunction

function! dotfiles#get_gui_type()
  if exists('g:ginit_loaded') || has('gui_running')
    return g:GUI_TYPE_RUNNING
  endif
  return g:GUI_TYPE_NOT_RUNNING
endfunction

function! dotfiles#is_gui_running()
  return dotfiles#get_gui_type() == g:GUI_TYPE_RUNNING
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

function! dotfiles#set_gui_font(font_height_pt)
  let font_name = 'Cica'
  let height = 'h' . a:font_height_pt
  let options = [font_name, height]
  if dotfiles#is_windows() && dotfiles#is_vim()
    let charset = 'cSHIFTJIS'
    add(options, charset)
    let quality = 'qDRAFT'
    add(options, quality)
  endif
  let guifont_string = join(options, ':')
  let &guifont = guifont_string
endfunction
