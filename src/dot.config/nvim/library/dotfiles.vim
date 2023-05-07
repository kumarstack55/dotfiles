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

  command! MyFontSize13ExSmall call s:set_gui_font(s:FONT_SIZE_EXSMALL)
  command! MyFontSize14Small call s:set_gui_font(s:FONT_SIZE_SMALL)
  command! MyFontSize10Normal call s:set_gui_font(s:FONT_SIZE_NORMAL)
  command! MyFontSize11Large call s:set_gui_font(s:FONT_SIZE_LARGE)
  command! MyFontSize12ExLarge call s:set_gui_font(s:FONT_SIZE_EXLARGE)
endfunction

function! dotfiles#get_pythonthreedll() abort
  if !has("win32") || has("nvim")
    return ""
  endif

  let unsorted_dirs = split(glob('C:\Python3*'), "\n")

  let dirs = reverse(sort(unsorted_dirs, { a, b ->
    \ str2nr(matchstr(a, '\d\+')[1:]) - str2nr(matchstr(b, '\d\+')[1:])}))

  for dir in dirs
    let ver = matchstr(dir, '\d\+')
    let dll_name = printf("python%d.dll", ver)
    let dll_path = dotfiles#path#join([dir, dll_name])

    if filereadable(dll_path)
      return dll_path
    endif
  endfor

  return ""
endfunction

function! dotfiles#set_pythonthreedll() abort
  let dll_path = dotfiles#get_pythonthreedll()
  if dll_path != ""
    let &pythonthreedll = dll_path
  endif
endfunction

function! dotfiles#get_python3_host_prog() abort
  if !has("win32") || !has("nvim")
    return ""
  endif

  let unsorted_dirs = split(glob('C:\Python3*'), "\n")

  let dirs = reverse(sort(unsorted_dirs, { a, b ->
    \ str2nr(matchstr(a, '\d\+')[1:]) - str2nr(matchstr(b, '\d\+')[1:])}))

  for dir in dirs
    let python3_path = dotfiles#path#join([dir, "python.exe"])
    if executable(python3_path)
      return python3_path
    endif
  endfor
  return ""
endfunction

function! dotfiles#set_python3_host_prog() abort
  let host_prog = dotfiles#get_python3_host_prog()
  if host_prog != ""
    let g:python3_host_prog = host_prog
  endif
endfunction

" function! dotfiles#stdpath(what) abort
"   if has('nvim')
"     return stdpath(what)
"   endif
"
"   if what != "config"
"     throw "not implemented"
"   endif
"
"   let xdg_config_home_key = "XDG_CONFIG_HOME"
"   let env = environ()
"   if has_key(env, xdg_config_home_key)
"     let xdg_config_home = env[l:xdg_config_home_key]
"   else
"     let xdg_config_home = "~/.config"
"   endif
" endfunction
