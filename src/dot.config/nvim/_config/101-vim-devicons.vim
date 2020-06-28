if empty(globpath(&rtp, 'autoload/vim-devicons.vim'))
  finish
endif

" vim内で使うエンコーディングを指定する
set encoding=utf8

" East Asian Width Class Ambiguous を2文字幅で扱う
set ambiwidth=double

if g:enable_devicons
  if dotfiles#is_windows() && dotfiles#is_gui_running()
    " gvim で encoding=utf8 かつメニューを日本語で表示させると、
    " 表示がおかしくなるため、英語表示とする。
    set langmenu=en_US
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
  endif

  " フォルダアイコンの表示をON
  let g:WebDevIconsUnicodeDecorateFolderNodes = 1
endif

command! MyDevIconsEnable call dotfiles#devicons_enable()
command! MyDevIconsDisable call dotfiles#devicons_disable()
command! MyDevIconsToggle call dotfiles#devicons_toggle()
