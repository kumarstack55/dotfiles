function! dotfiles#path#join(pathparts, ...) abort
  let sep
    \ = a:0 > 0 ? a:1
    \ : has("win32") ? "\\"
    \ : "/"
  return join(a:pathparts, sep)
endfunction
