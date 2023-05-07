function! dotfiles#path#join(pathparts, ...) abort
  let sep
    \ = a:0 > 0 ? a:1
    \ : has("win32") ? "\\"
    \ : "/"
  return join(a:pathparts, sep)
endfunction

function! dotfiles#path#stdpath(what) abort
  if has('nvim')
    return stdpath(a:what)
  endif

  if a:what != "config"
    return ""
  endif

  let xdg_config_home_key = "XDG_CONFIG_HOME"
  let env = environ()
  let xdg_config_home
    \ = has_key(env, xdg_config_home_key) ? env[xdg_config_home_key]
    \ : has("win32") ? "~/AppData/Local"
    \ : "~/.config"

  let config_path = dotfiles#path#join([xdg_config_home, "nvim"])
  return config_path
endfunction
