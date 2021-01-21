# .gitconfig_windows.inc
[core]
	#editor = gvim -c \"set fenc=utf-8\"

	# Windows 環境でのコミットログ編集時、
	# エディタ実行時の環境変数 TERM=cygwin があるため、
	# nvim は表示が崩れた。
	# nvim-qt を設定すると TERM=cygwin でも表示は崩れなかった。
	#editor = nvim-qt

	# 日本語のパスがあってもクォートしない
	quotepath=false

	# git diff で末尾に ^M が表示されることを回避する
	# https://stackoverflow.com/a/28076848/12786161
	whitespace=cr-at-eol
[color]
	diff=true
	status=true
	branch=true
	interactive=true
# vim:ft=conf:
