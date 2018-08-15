"""Converts SAS import file to JSON to be used by R script
Some light regex replace cleanup already done on vac*txt files.
"""
import csv
import json
import re

microdata_conf = {}

LINE_RE = re.compile("^(\d+?) (.+) (?:comma)?(\d+(?:\.\d+)?)$")
with open('vac.txt') as f:
    for line in f.readlines():
        # indexes start at 1, not 0 (lol)
        m = re.match(LINE_RE, line)
        if not m:
            print(f'Bad vac line {line}')
            continue

        char_idx = m.group(1)
        var_name = m.group(2).lower()
        substr_len = m.group(3)

        microdata_conf[var_name] = {
            'idx': char_idx,
            'var': var_name,
            'len': substr_len,
        }

LABEL_RE = re.compile("^(.+?)='(.+)'$")
with open('vac_labels.txt') as f:
    for line in f.readlines():
        m = re.match(LABEL_RE, line)

        if not m:
            print(f'Bad label line {line}')
            continue

        var_name = m.group(1).lower()
        item_name = m.group(2)

        if var_name not in microdata_conf:
            print(f'Unmatched var {var_name}')
            continue

        microdata_conf[var_name]['item'] = item_name

# print(json.dumps(list(microdata_conf.values()), sort_keys=True, indent=2))

with open('out.csv', 'w') as f:
    fields = ['idx', 'var', 'len', 'item']
    wr = csv.DictWriter(f, fieldnames=fields)
    wr.writeheader()
    for d in microdata_conf.values():
        wr.writerow(d)
