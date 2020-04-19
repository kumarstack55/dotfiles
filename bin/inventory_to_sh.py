#!/usr/bin/env python

import json
import argparse


def print_inventory_item(inventory_item):
    parts = list()
    for k, v in inventory_item.items():
        assert "'" not in v
        parts.append("item_%s='%s'" % (k, v))
    print(' '.join(parts))


def print_inventory(data):
    for item in data.get('inventory'):
        print_inventory_item(item)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('json', nargs=1)
    args = parser.parse_args()

    with open(args.json[0]) as f:
        data = json.load(f)
        print_inventory(data)
