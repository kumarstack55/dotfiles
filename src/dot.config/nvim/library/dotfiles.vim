function! dotfiles#is_win32_vim()
  return has('win32') && !has('nvim') && !has('gui_running')
endfunction

function! dotfiles#is_win32_nvim()
  return has('win32') && has('nvim')
endfunction

function! dotfiles#is_win32_gvim()
  return has('win32') && !has('nvim') && has('gui_running')
endfunction

function! dotfiles#is_win32_wsl_vim()
  return has('linux') && !has('nvim') &&
        \ (stridx(system('uname -r'), '-microsoft-') != -1)
endfunction

function! dotfiles#is_win32_wsl_nvim()
  return has('linux') && has('nvim') && has('wsl')
endfunction

function! dotfiles#is_win32_cygwin_vim()
  return has('win32unix') && !has('nvim')
endfunction

function! dotfiles#is_linux_vim()
  return has('linux') && !has('nvim')
endfunction

function! dotfiles#is_linux_nvim()
  return has('linux') && has('nvim')
endfunction
