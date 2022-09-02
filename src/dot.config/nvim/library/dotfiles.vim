function! dotfiles#is_win32_vim()
  return has('win32') && !has('nvim') && !has('gui_running')
endfunction

function! dotfiles#is_win32_nvim()
  return has('win32') && has('nvim') && !exists('g:ginit_loaded')
endfunction

function! dotfiles#is_win32_nvimqt()
  return has('win32') && has('nvim') && exists('g:ginit_loaded')
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

function! dotfiles#define_font_size_commands()
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
endfunction
