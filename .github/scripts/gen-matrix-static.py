#!/usr/bin/env python3

import json
import sys

from ruamel.yaml import YAML

yaml = YAML(typ='safe')
entries = []

with open('.github/data/matrices.yaml') as f:
    data = yaml.load(f)

static = data['static']
meta = data['meta']

entries = []

match sys.argv[1]:
    case 'build':
        for rev in static['revisions']:
            entries.append({
                'revision': rev,
            })
    case 'pr':
        for rev, platforms in static['revisions'].items():
            for platform in [x for x in platforms if x != meta['native-platform']]:
                entries.append({
                    'revision': rev,
                    'platform': platform,
                })
    case 'publish':
        for rev, platforms in static['revisions'].items():
            tags = []

            for registry in meta['registries']:
                tags.append(f'{registry}{meta["image-prefix"]}{static["image"]}:{rev}')

                if rev == meta['latest-rev']:
                    tags.append(f'{registry}{meta["image-prefix"]}{static["image"]}:latest')

            entries.append({
                'revision': rev,
                'platforms': ','.join(platforms),
                'tags': ','.join(tags)
            })
    case _:
        raise ValueError(f'Unrecognized matrix type {sys.argv[1]}')

entries.sort(key=lambda k: k['revision'])
matrix = json.dumps({'include': entries}, sort_keys=True)
print(matrix)
