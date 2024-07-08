#!/usr/bin/env python3

import json
import sys

from ruamel.yaml import YAML

yaml = YAML(typ='safe')
entries = []

with open('.github/data/matrices.yaml') as f:
    data = yaml.load(f)

pkgs = data['legacy']
meta = data['meta']

entries = []

match sys.argv[1]:
    case 'build':
        for distro in pkgs['distros']:
            entries.append({
                'os': distro['os'],
            })
    case 'pr':
        for distro in pkgs['distros']:
            for platform in [x for x in distro['platforms'] if x != meta['native-platform']]:
                entries.append({
                    'os': distro['os'],
                    'platform': platform,
                })
    case 'publish':
        for distro in pkgs['distros']:
            tags = []

            for registry in meta['registries']:
                tags.append(f'{registry}{meta["image-prefix"]}{pkgs["image"]}:{distro["os"]}')

            entries.append({
                'os': distro['os'],
                'platforms': ','.join(distro['platforms']),
                'tags': ','.join(tags)
            })
    case _:
        raise ValueError(f'Unrecognized matrix type {sys.argv[1]}')

entries.sort(key=lambda k: k['os'])
matrix = json.dumps({'include': entries}, sort_keys=True)
print(matrix)
