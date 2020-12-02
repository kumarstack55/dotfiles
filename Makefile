# inventory.txtの生成はPythonを使うがPythonが入っていない処理系が
# あるので、あらかじめリポジトリ内に生成したファイルを入れておく。
inventory.txt: inventory.json
	./bin/inventory_to_sh.py $< >$@
# vim:set ts=8 sw=8 noet:
