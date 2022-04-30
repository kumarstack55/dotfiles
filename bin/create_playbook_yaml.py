#!/usr/bin/env python
import argparse
import json
import sys
import yaml


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
            'infile', nargs='?', type=argparse.FileType('r'),
            default=sys.stdin)
    ns = parser.parse_args()

    data = json.load(ns.infile)
    print(yaml.dump(data))
