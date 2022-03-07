# Cheatsheet

## システムのクリップボードを扱う。

* gvim の場合、 `Shift+Insert` でペーストできる。
* gvim, nvim の場合、 `"*p` でレジスタ経由でペーストできる。

## リテラルで検索する。

検索レジスタに検索文字列を入れることでできる。
以下は `"` レジスタの中身を検索する場合の例です。

```vim
:echo v:register
:echo getreg(v:register)
:let @/ = trim(getreg(v:register))
:set hlsearch
```

## ファイルパスを探す。

### ctrlp.vim

C-p 後に編集したいファイル名の一部を入力する。

### Fern

```vim
:Fern .
```

```vim
:Fern . -drawer
```

```vim
:Fern %:h
```

* `?` でヘルプを出す。
* `!` で隠しファイルを表示する。

選択したファイルのあるディレクトリに cd する:

```vim
:lcd %:h
```

ブックマークを開く:

```vim
:Fern bookmark:///
```

### NERDTree

```vim
:NERDTree
```

## ディレクトリ内を探す

### Vaffe

```vim
:Vaffe
```

ヘルプを表示する。

```vim
:help :Vaffe
```

* `h` : 親ディレクトリに移動する。
* `l` : 選択中のディレクトリの中に移動する。
* `.` : 隠しファイルの表示/非表示を切り替える。
* `o` : ディレクトリを作る。
* `i` : ファイルを作る。
* `<Space>` : 選択/選択解除する。
* `d` : 選択済みを消す。
* `r` : 選択済みの名前を変える。

### VimFiler

```vim
:VimFiler
```

### unite

```vim
:Unite file buffer
```

## ステータスを制御する。

## バッファ群を制御する。

### bufexplorer

```vim
:BufExplorer
```

## ウィンドウを制御する。

### submode

```
vim
:vsplit
:split
C-w +++---
C-w >>><<<
```

### vim-indent-guides

`<Leader>ig` でインデントガイドの有効無効を切り替える。
なお、 `<Leader>` のデフォルトは `\` キーである。

### vim-surround

Visualモードで範囲を選択して S + '記号' と入力すると、記号で括る

```
vim
iThis is a selected text.<ESC>
/a<enter>
v/t<enter>nn
S"
```

## 外部コマンドを実行する。

### Terminal を操作する。

ターミナルを開く。
ターミナルは Terminal-Normal モードになる。

```vim
:Terminal
```

モードを `Terminal-Normal` から `Terminal-Job` モードに変える。

```
i
```

モードを `Terminal-Job` から `Terminal-Normal` モードに変える。

```
Ctrl-\ Ctrl-n
```

### vim-quickrun

バッファ内を実行して、結果が別バッファで得られる。
Python 等のコードを書いて実行する等が便利。

`:QuickRun<enter>`

### vim-slime

```
$ tmux
C-b :split-window         --> 画面が水平2分割される
C-b q                     --> 画面の番号を確認
vim
idate<ESC>                --> 1行目に date を書く
C-c C-c
tmux socket name: default
tmux target pane: :0.0    --> 初回はどの pane に出力するか決める
                          --> date が実行される
C-c C-c                   --> 2回目以降は pane 指定不要となる
```

## スニペットを使う。

### vim-sonictemplate

```
$ vim hoge.py
:Template <tab>
  --> テンプレート一覧が表示される

in.ii<c-y><c-b>
  --> 後置補完を行う

<esc>
echo g:sonictemplate_vim_template_dir
  --> 保管定義のディレクトリパスが表示される
```

```
$ vim hoge.md

ipython.code<c-y><c-b>
```

#### python

```vim
:Template<tab>
```

```vim
:Template main
```

```
i
a.i
c-y c-b
    --> a = input()

a.ili
c-y c-b
    --> a = input_li()
```

#### markdown

```
i
console.pre
c-y c-b
```

### vim-snippets

```
$ vim hoge.c
main<tab>
  --> main 関数のひな型作られる
$ vim hoge.yml
:set ft=ansible
lineinfile<tab>
```

### vim-doge

```
$ vim a.py
idef a():
pass<ESC>:1<CR>\d
```

```
$ vim a.sh
ia() {
}<ESC>:1<CR>\d
```

## コード開発を支援する。

### vim-lsp

```
:LspDocumentDiagnostics
```

```
:LspNextDiagnostics
```

### ale

```
$ nvim x.py
:ALEInfo
```

## Git

### vim-fugitive

* コミットログを確認するため、quickfix にログを表示する
    * `:Glog | copen`
* キーワード検索して、quickfix に検索結果を表示する
    * `:Ggrep 検索したいワード | copen`
* 編集箇所がどのコミットか確認する
    * `:Gblame`
* コミットするファイルを選ぶ
    * `:Gstatus`
        * 行選択して - で add/reset に。 p でパッチ表示。
* コミット予定の差分を確認する
    * `:Git! diff --cached`
* コミットする
    * `:Git commit`
* プッシュする
    * `:Git push`

## Python

### vim-coverage

```sh
$ pip install --user coverage
$ nvim a.py
:CoverageShow
```

### vim-flake8

flake8 を実行し、quickfix に表示する。

```sh
$ vim x.py
F7
```

## Ansible

### ansible-vim

初期設定:

```sh
$ sudo yum install epel-release -y
$ sudo yum-config-manager --disable epel
$ sudo yum --enablerepo=epel install ansible -y
$ cd ~/.vim/bundles/repos/github.com/pearofducks/ansible-vim/UltiSnips
$ ./generate.py
```

使い方:

```sh
$ mkdir -pv /tmp/playbooks
$ vim /tmp/playbooks/hoge.yml
i- name: hoge<enter>lineinfile<tab>
  --> lineinfile の引数が列挙される
```

<!-- vim:set nofoldenable: -->
