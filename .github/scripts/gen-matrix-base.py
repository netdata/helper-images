#!/usr/bin/env python3

import json
import sys

from ruamel.yaml import YAML

yaml = YAML(typ='safe')
entries = []

with open('.github/data/matrices.yaml') as f:
    data = yaml.load(f)

base = data['base']
meta = data['meta']

entries = []

match sys.argv[1]:
    case 'build':
        for rev in base['revisions']:
            for image in base['images']:
                entries.append({
                    'revision': rev,
                    'image': image,
                })
    case 'pr':
        for rev in base['revisions']:
            for image in base['images']:
                for platform in [x for x in base['platforms'] if x != meta['native-platform']]:
                    entries.append({
                        'revision': rev,
                        'image': image,
                        'platform': platform,
                    })
    case 'publish':
        for rev in base['revisions']:
            for image in base['images']:
                tags = []

                for registry in meta['registries']:
                    tags.append(f'{ registry }{ meta["image-prefix"] }{ image }:{ rev }')

                    if rev == meta['latest-rev']:
                        tags.append(f'{ registry }{ meta["image-prefix"] }{ image }:latest')

                entries.append({
                    'revision': rev,
                    'image': image,
                    'platforms': ','.join(base['platforms']),
                    'tags': ','.join(tags)
                })
    case _:
        raise ValueError(f'Unrecognized matrix type { sys.argv[1] }')

entries.sort(key=lambda k: k['revision'])
matrix = json.dumps({'include': entries}, sort_keys=True)
print(matrix)
