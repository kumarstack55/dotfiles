inventory.sh: inventory.json
	./bin/inventory_to_sh.py $< >$@
# vim:set ts=8 sw=8 noet:
