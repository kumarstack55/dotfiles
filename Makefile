TARGET=bin/installer.sh

all: $(TARGET)

bin/installer.sh: playbook.json templates/installer.sh.j2 bin/playbook_to_bash.py
	python bin/playbook_to_bash.py --source $< >$@.tmp
	chmod +x $@.tmp
	mv -fv $@.tmp $@

clean:
	rm -fv $(TARGET)
# vim:set ts=8 sw=8 noet:
