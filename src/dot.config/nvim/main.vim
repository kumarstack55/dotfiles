" $HOME/.config/nvim/main.vim

let s:script_dir = expand('<sfile>:p:h')
let s:plugins_file = s:script_dir . "/plugins.vim"
execute "source " . s:plugins_file

" フォントサイズを設定する
if dotfiles#is_gui_running()
  command! MyFontSizeSmall call dotfiles#set_gui_font(g:FONT_SIZE_SMALL)
  command! MyFontSizeNormal call dotfiles#set_gui_font(g:FONT_SIZE_NORMAL)
  command! MyFontSizeLarge call dotfiles#set_gui_font(g:FONT_SIZE_LARGE)
  command! MyFontSizeExLarge call dotfiles#set_gui_font(g:FONT_SIZE_EXLARGE)
endif

" tabstop, shiftwidth を変える
command! MyTabstopWidth2 call dotfiles#set_tabstop(2)
command! MyTabstopWidth3 call dotfiles#set_tabstop(3)
command! MyTabstopWidth4 call dotfiles#set_tabstop(4)

" ファイルタイプ用の設定にする
command! MyFiletypeMarkdown call dotfiles#set_filetype_markdown()
command! MyFiletypeRst call dotfiles#set_filetype_rst()

" カーソル行の直後にmodelineを加える
command! MyModelineAppend call dotfiles#add_modeline()

" Tagbar をリロードする
command! MyTagbarReload call dotfiles#tagbar_reload()

if dotfiles#is_gui_running()
  " すべてのモードでマウスを有効にする
  set mouse=a
endif

" Visualモード時に１文字選択する
" マウス動作をxtermライクのプロファイルにする
behave xterm

" 変化が見られないのでしばらくしたら消す
" ESC応答を早めるため、キーコードシーケンス完了の待ち時間を
" 短くする
" https://qiita.com/k2nakamura/items/fa19806a041d0429fc9f
"set ttimeoutlen=10

" split,close時、ウィンドウの自動リサイズを行わない
set noequalalways

" ビジュアルベルを無効にする
set novisualbell

" 行番号を表示させる
set number

" カラースキームを設定する
"colorscheme apprentice
colorscheme gruvbox

if dotfiles#is_gui_running()
  " フォントサイズを設定する
  " また、プリント時に文字化けを回避するために追加した
  MyFontSizeNormal
endif

if dotfiles#is_gui_running() && dotfiles#is_vim()
  " ツールバーを非表示にする
  set guioptions-=T
endif

if dotfiles#is_gui_running()
  " insert モードで IM を OFF にする
  set iminsert=0

  " 検索パタンを入力時、 IM を iminsert 設定値で設定する
  set imsearch=-1
endif

" 既存ファイル編集時のエンコーディング候補順序を定める
set fileencodings=utf-8,cp932,utf-16le

" ファイル再オープン時にカーソルを移動する
" (:help restore-cursor)
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" modelineの認識は先頭と末尾の行数を指定する
set modelines=5

" カーソルの上下端で表示するスクリーン行数の最小数を指定する
set scrolloff=5

" カーソル行を表示させる
set cursorline

" 長い行を入力するときvimが改行を入れないようにする
set textwidth=0

" 折り畳み行の行頭に視覚的なインデントを入れる
if v:version > 704
  set breakindent
endif

" 選択範囲をクリップボードに送る
" VISUALで選択した範囲は即座にクリップボードに送られる
if dotfiles#is_gui_running()
  " 選択範囲をコピーする
  set guioptions+=a
elseif dotfiles#is_vim()
  set clipboard=autoselect
else
  " autoselect を設定できない環境では
  " autoselect に近い設定を noremap で設定しておく

  " S-Insert でクリップボードをペーストする
  nnoremap <S-Insert> "*p
  inoremap <S-Insert> <ESC>"*pi

  " マウス左ボタンを離したらクリップボードにコピーする
  vnoremap <LeftRelease> "*ygv

  " 選択範囲を変えたらコピーする
  " カーソル移動のたびにコピーして選択しなおすのは高コストで、
  " 選択の行数が多いときに使用に耐えない
  " そこで、VISUALをやめるときだけコピーを行う
  vnoremap <ESC> "*ygv<ESC>
endif

" 検索キーワードを強調させない
set nohlsearch

" 置換時に置換結果のプレビューをプレビューウィンドウで表示する
if dotfiles#is_neovim()
  set inccommand=split
endif

" バックアップファイル (*~) を作らない
set nobackup

" 同ファイルの複数編集に気づけるようスワップファイルを作る
set swapfile

" Windows環境では次のパスにスワップを作る
if dotfiles#is_windows()
  set directory=$TEMP,c:\\tmp,c:\\temp,.
endif

" undo ファイル (un~) を作らない
set noundofile

"-----------------------------------------
" submode

" ウィンドウの大きさを C-w <>+- で変更する
call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>+')
call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>-')
call submode#map('winsize', 'n', '', '>', '<C-w>>')
call submode#map('winsize', 'n', '', '<', '<C-w><')
call submode#map('winsize', 'n', '', '+', '<C-w>+')
call submode#map('winsize', 'n', '', '-', '<C-w>-')

" 使い方
" vim
" :vsplit
" :split
" C-w +++---
" C-w >>><<<

"-----------------------------------------
" NERDTree

" 開始時にブックマークを表示
let NERDTreeShowBookmarks = 1
" 隠しファイルを表示
let NERDTreeShowHidden = 1
" 隠しファイルは先頭に表示
let NERDTreeSortHiddenFirst = 1

" 使い方
" :NERDTree

"-----------------------------------------
" VimFiler

" 使い方
" :VimFiler

"-----------------------------------------
" unite

" 使い方
" :Unite file buffer

"-----------------------------------------
" ctrlp.vim

" 使い方
" C-p 後に編集したいファイル名の一部を入力する

"-----------------------------------------
" vim-devicons

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

"-----------------------------------------
" bufexplorer

" 使い方
" :BufExplorer

"-----------------------------------------
" lightline.vim

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

"-----------------------------------------
" vim-indent-guides

" バックグラウンドdarkにしてインデントガイドの色をよくする
set background=dark

" vim起動時に有効にする
let g:indent_guides_enable_on_vim_startup = 1

" サイズは1文字で表現する
let g:indent_guides_guide_size = 1

" nerdtree は除外する
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']

" 使い方
" <Leader>ig --> インデントガイドの有効無効を切り替える
" なお、<Leader> のデフォルトは \ キー

"-----------------------------------------
" vim-quickrun

" 使い方
" :QuickRun<enter> でバッファ内を実行すると結果が別バッファで
" 得られる。Python 等のコードを書いて実行する等が便利。

"-----------------------------------------
" vim-slime

" 使い方
" $ tmux
" C-b :split-window         --> 画面が水平2分割される
" C-b q                     --> 画面の番号を確認
" vim
" idate<ESC>                --> 1行目に date を書く
" C-c C-c
" tmux socket name: default
" tmux target pane: :0.0    --> 初回はどの pane に出力するか決める
"                           --> date が実行される
" C-c C-c                   --> 2回目以降は pane 指定不要となる

"-----------------------------------------
" vim-surround

" Visualモードで範囲を選択して S + '記号' と入力すると、記号で括る
" vim
" iThis is a selected text.<ESC>
" /a<enter>
" v/t<enter>nn
" S"

"-----------------------------------------
" vim-fugitive

" コミットログを確認する
"   :Glog | copen
"     --> quickfix にログを表示
" キーワード検索する
"   :Ggrep 検索したいワード | copen
"     --> quickfix に検索結果を表示
" 編集箇所がどのコミットか確認する
"   :Gblame
" コミットするファイルを選ぶ
"   :Gstatus
"     --> 行選択して、 - で add/reset に。 p でパッチ表示。
" コミット予定の差分を確認する
"   :Git! diff --cached
"     --> git diff --cached
"   :Greview
" コミットする
"   :Gcommit
" プッシュする
"   :Gpush

"-----------------------------------------
" vim-snippets

command! MyUltiSnipsRefreshSnippets
      \ call UltiSnips#RefreshSnippets()

" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" 使い方
" $ vim hoge.c
" main<tab>
"   --> main 関数のひな型作られる
" $ vim hoge.yml
" :set ft=ansible
" lineinfile<tab>

" 他にもスニペット管理があるが、
" ansible-vim のディレクトリ名にあわせて UltiSnips を選択した。

"-----------------------------------------
" ansible-vim

" INSERTで２つの改行の後でインデントを完全にリセットする
let g:ansible_unindent_after_newline = 1

" key=value フォーマットを強調して表示する
let g:ansible_attribute_highlight = "ob"

" name 属性を強調して表示する
let g:ansible_name_highlight = 'd'

" register, always_run, 等のキーワードを強調して表示する
let g:ansible_extra_keywords_highlight = 1

" include, until, 等のキーワードの強調を変える
let g:ansible_normal_keywords_highlight = 'Constant'

" with_ 等キーワードの強調を変える
let g:ansible_with_keywords_highlight = 'Constant'

" 初期設定:
" $ sudo yum install epel-release -y
" $ sudo yum-config-manager --disable epel
" $ sudo yum --enablerepo=epel install ansible -y
" $ cd ~/.vim/bundles/repos/github.com/pearofducks/ansible-vim/UltiSnips
" $ ./generate.py

" 使い方:
" $ mkdir -pv /tmp/playbooks
" $ vim /tmp/playbooks/hoge.yml
" i- name: hoge<enter>lineinfile<tab>
"   --> lineinfile の引数が列挙される

"-----------------------------------------
" vim-markdown

" folding 設定を無効にする
let g:vim_markdown_folding_disabled = 1

"let g:vim_markdown_new_list_item_indent = 0

" 箇条項目の点を挿入しない
let g:vim_markdown_auto_insert_bullets = 0

"-----------------------------------------
" tagbar

let g:tagbar_type_ansible = {
    \ 'ctagstype' : 'yaml',
    \ 'kinds' : [ 't:tasks' ],
    \ 'sort' : 0
  \ }

let g:tagbar_type_rst = {
    \ 'ctagstype': 'rst',
    \ 'ctagsbin' : '~/.vim/plugged/rst2ctags/rst2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [ 's:sections', 'i:images' ],
    \ 'sro' : '|',
    \ 'kind2scope' : { 's' : 'section' },
    \ 'sort': 0,
  \ }

let g:tagbar_type_ps1 = {
    \ 'ctagstype': 'powershell',
    \ 'kinds': [
      \ 'f:function',
      \ 'i:filter',
      \ 'a:alias'
    \ ]
  \ }

" let g:tagbar_type_markdown = {
"     \ 'ctagstype': 'markdown',
"     \ 'ctagsbin' : '~/.vim/plugged/markdown2ctags/markdown2ctags.py',
"     \ 'ctagsargs': '-f - --sort=yes',
"     \ 'kinds' : [
"       \ 's:sections',
"       \ 'i:images'
"     \ ],
"     \ 'sro' : '|',
"     \ 'kind2scope' : {
"       \ 's' : 'section',
"     \ },
"     \ 'sort': 0,
"   \ }

let g:tagbar_type_markdown = {
      \ 'ctagsbin': 'mdctags',
      \ 'ctagsargs': '',
      \ 'kinds': [
        \ 'a:h1:0:0',
        \ 'b:h2:0:0',
        \ 'c:h3:0:0',
        \ 'd:h4:0:0',
        \ 'e:h5:0:0',
        \ 'f:h6:0:0',
      \ ],
      \ 'sro': '::',
      \ 'kind2scope' : {
        \ 'a': 'h1',
        \ 'b': 'h2',
        \ 'c': 'h3',
        \ 'd': 'h4',
        \ 'e': 'h5',
        \ 'f': 'h6',
      \ },
      \ 'scope2kind' : {
        \ 'h1': 'a',
        \ 'h2': 'b',
        \ 'h3': 'c',
        \ 'h4': 'd',
        \ 'h5': 'e',
        \ 'h6': 'f',
      \}
    \}

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
      \ 'p:package',
      \ 'i:imports:1',
      \ 'c:constants',
      \ 'v:variables',
      \ 't:types',
      \ 'n:interfaces',
      \ 'w:fields',
      \ 'e:embedded',
      \ 'm:methods',
      \ 'r:constructor',
      \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
      \ 't' : 'ctype',
      \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
      \ 'ctype' : 't',
      \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
  \ }

let g:tagbar_type_rust = {
    \ 'ctagstype' : 'rust',
    \ 'kinds' : [
      \'T:types,type definitions',
      \'f:functions,function definitions',
      \'g:enum,enumeration names',
      \'s:structure names',
      \'m:modules,module names',
      \'c:consts,static constants',
      \'t:traits',
      \'i:impls,trait implementations',
    \]
  \}

"-----------------------------------------
" vim-flake8

let g:flake8_show_in_gutter=1

" 使い方:
" $ vim x.py
" F7
"   --> flake8 が実行され QuickFix に表示される

"-----------------------------------------
" dense-analysis/ale

if dotfiles#version_ge_8()
  " https://github.com/dense-analysis
  " 5.ix. How can I navigate between errors quickly?
  nmap <silent> <C-k> <Plug>(ale_previous_wrap)
  nmap <silent> <C-j> <Plug>(ale_next_wrap)
endif

" 使い方:
" $ nvim x.py
" :ALEInfo

"-----------------------------------------
" vim-doge

" 使い方:
"
" $ vim a.py
" idef a():
" pass<ESC>:1<CR>\d
"
" $ vim a.sh
" ia() {
" }<ESC>:1<CR>\d

let g:doge_doc_standard_python = 'google'

" デフォルト値だが指定ない場合に補完されなかったため明示指定する
let g:doge_doc_standard_sh = 'google'

"-----------------------------------------
" vim-coverage

" 使い方:
"
" $ pip install --user coverage
" $ nvim a.py
" :CoverageShow

call glaive#Install()

"-----------------------------------------

" ファイルタイプを定める

" *.yml
autocmd BufRead,BufNewFile *.yml
      \ setlocal indentexpr=""

" Ansible
autocmd BufRead,BufNewFile */playbooks/*.yml
      \ setlocal filetype=yaml.ansible
autocmd BufRead,BufNewFile */ansible/*.yml
      \ setlocal filetype=yaml.ansible

" config
autocmd BufRead,BufNewFile */dot.gitconfig_local.inc
      \ setlocal filetype=conf
autocmd BufRead,BufNewFile */.gitconfig_local.inc
      \ setlocal filetype=conf

" Markdwon
autocmd BufRead,BufNewFile *.md
  \ setlocal filetype=markdown shiftwidth=4 softtabstop=4
  \ tabstop=4 expandtab

" PowerShell
" vim-ps1 と UltiSnips を同時に利用するとコメント行の
" shift に失敗する。回避するに smartindent を無効にする。
autocmd BufRead,BufNewFile *.ps1
      \ setlocal nosmartindent
autocmd BufRead,BufNewFile *.psm1
      \ setlocal nosmartindent
