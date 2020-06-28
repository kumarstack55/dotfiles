set laststatus=2 " 常にステータスを表示させる
let g:lightline = {}
let g:lightline.colorscheme = 'jellybeans'
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
if dotfiles#version_ge_8()
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
    call dotfiles#devicons_enable()
  else
    call dotfiles#devicons_disable()
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
    return g:enable_devicons ? "" : "[RO]"
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
  if dotfiles#version_ge_8()
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

