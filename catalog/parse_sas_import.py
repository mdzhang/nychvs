"""Converts text files derived from SAS import file to csv,
to be used generically by R
Script for expanding microdata
"""
import argparse
import csv
import os
import re
import typing as T

ENCODING_RE = re.compile("^(\d+?) (.+) (?:comma)?(\d+(?:\.\d+)?)$")
LABEL_RE = re.compile("^(.+?)='(.+)'$")


def parse_catalog(encoding_file, labels_file) -> T.Iterable[dict]:
    microdata_conf = {}

    with open(encoding_file) as f:
        for line in f.readlines():
            # indexes start at 1, not 0 (lol)
            m = re.match(ENCODING_RE, line)
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

    with open(labels_file) as f:
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

    return list(microdata_conf.values())


def write_catalog(catalog, outfile):
    with open(outfile, 'w') as f:
        fields = ['idx', 'var', 'len', 'item']
        wr = csv.DictWriter(f, fieldnames=fields)
        wr.writeheader()
        for d in catalog:
            wr.writerow(d)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'dir_name',
        help=('directory with encoding.txt and labels.txt files '
              'to convert to a result.csv file in same directory'))
    args = parser.parse_args()

    basedir = os.path.dirname(os.path.abspath(__file__))
    subdir = os.path.join(basedir, args.dir_name)

    encoding_file = os.path.join(subdir, 'encoding.txt')
    labels_file = os.path.join(subdir, 'labels.txt')
    output_file = os.path.join(subdir, 'result.csv')

    catalog = parse_catalog(encoding_file, labels_file)
    write_catalog(catalog, output_file)
