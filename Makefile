TARGET=inventory.txt bin/installer.sh

all: $(TARGET)

# inventory.txtの生成はPythonを使うがPythonが入っていない処理系が
# あるので、あらかじめリポジトリ内に生成したファイルを入れておく。
inventory.txt: inventory.json
	./bin/inventory_to_sh.py $< >$@.tmp
	mv -fv $@.tmp $@

bin/installer.sh: playbook.json templates/installer.sh.j2 bin/playbook_to_bash.py
	python bin/playbook_to_bash.py --source $< >$@.tmp
	chmod +x $@.tmp
	mv -fv $@.tmp $@

clean:
	rm -f $(TARGET)
# vim:set ts=8 sw=8 noet:
