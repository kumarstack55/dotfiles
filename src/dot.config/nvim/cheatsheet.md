# Cheatsheet

## vim-fugitive

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
    * `:Greview`
    * `:Gcommit`
* プッシュする
    * `:Gpush`

## vim-surround

Visualモードで範囲を選択して S + '記号' と入力すると、記号で括る

```
vim
iThis is a selected text.<ESC>
/a<enter>
v/t<enter>nn
S"
```

## vim-snippets

```
$ vim hoge.c
main<tab>
  --> main 関数のひな型作られる
$ vim hoge.yml
:set ft=ansible
lineinfile<tab>
```

## ansible-vim

初期設定:

```
$ sudo yum install epel-release -y
$ sudo yum-config-manager --disable epel
$ sudo yum --enablerepo=epel install ansible -y
$ cd ~/.vim/bundles/repos/github.com/pearofducks/ansible-vim/UltiSnips
$ ./generate.py
```

使い方:

```
$ mkdir -pv /tmp/playbooks
$ vim /tmp/playbooks/hoge.yml
i- name: hoge<enter>lineinfile<tab>
  --> lineinfile の引数が列挙される
```

## vim-flake8

flake8 を実行し、quickfix に表示する。

```
$ vim x.py
F7
```

## nerdtree

```
:NERDTree
```

## vim-devicons

```
MyDevIconsEnable
MyDevIconsDisable
MyDevIconsToggle
```

## submode

```
vim
:vsplit
:split
C-w +++---
C-w >>><<<
```

## vim-doge

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

## ale

```
$ nvim x.py
:ALEInfo
```

## vim-coverage

```
$ pip install --user coverage
$ nvim a.py
:CoverageShow
```

## vim-indent-guides

`<Leader>ig` でインデントガイドの有効無効を切り替える。
なお、 `<Leader>` のデフォルトは `\` キーである。

## VimFiler

`:VimFiler`

## unite

`:Unite file buffer`

## ctrlp.vim

C-p 後に編集したいファイル名の一部を入力する。

## bufexplorer

`:BufExplorer`

## vim-quickrun

バッファ内を実行して、結果が別バッファで得られる。
Python 等のコードを書いて実行する等が便利。

`:QuickRun<enter>`

## vim-slime

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
