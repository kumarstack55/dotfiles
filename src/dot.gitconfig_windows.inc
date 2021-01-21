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

[color]
	diff=false
	status=false
	branch=false
	interactive=false
# vim:ft=conf:
