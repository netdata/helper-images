#!/usr/bin/env python3

import json
import sys

from ruamel.yaml import YAML

yaml = YAML(typ='safe')
entries = []

with open('.github/data/matrices.yaml') as f:
    data = yaml.load(f)

pkgs = data['package-builders']
meta = data['meta']

entries = []

match sys.argv[1]:
    case 'build':
        for distro in pkgs['distros']:
            for rev in distro['revisions']:
                entries.append({
                    'os': distro['os'],
                    'revision': rev,
                })
    case 'pr':
        for distro in pkgs['distros']:
            for rev in distro['revisions']:
                for platform in [x for x in distro['platforms'] if x != meta['native-platform']]:
                    entries.append({
                        'os': distro['os'],
                        'revision': rev,
                        'platform': platform,
                    })
    case 'publish':
        for distro in pkgs['distros']:
            for rev in distro['revisions']:
                tags = []

                for registry in meta['registries']:
                    tags.append(f'{ registry }{ meta["image-prefix"] }{ pkgs["image"] }:{ distro["os"] }-{ rev }')

                    if rev == meta['latest-rev']:
                        tags.append(f'{ registry }{ meta["image-prefix"] }{ pkgs["image"] }:{ distro["os"] }')

                entries.append({
                    'revision': rev,
                    'os': distro['os'],
                    'platforms': ','.join(distro['platforms']),
                    'tags': ','.join(tags)
                })
    case _:
        raise ValueError(f'Unrecognized matrix type { sys.argv[1] }')

entries.sort(key=lambda k: k['revision'])
matrix = json.dumps({'include': entries}, sort_keys=True)
print(matrix)
