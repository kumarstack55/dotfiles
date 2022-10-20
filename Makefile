TARGET=bin/installer.sh

all: $(TARGET)

playbook.json: playbook.yml
	python3 bin/create_playbook_json.py $< >$@.tmp
	mv -fv $@.tmp $@

bin/installer.sh: playbook.json templates/installer.sh.j2 bin/playbook_to_bash.py
	python3 bin/playbook_to_bash.py --source $< >$@.tmp
	chmod +x $@.tmp
	mv -fv $@.tmp $@

clean:
	rm -fv $(TARGET)
# vim:set ts=8 sw=8 noet:
