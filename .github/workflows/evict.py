#!/usr/bin/env python3

# GitHub's @actions/cache action has the following properties:
# 1. It has a 10 GB limit (the bazel cache for this repo is about 2.4 GB).
# 2. It uses branch-specific caches.
#    - Feature branches can access caches from the default branch,
#      but not the other way around.
#    - Feature branches cannot access caches from each other.
#    - Cache eviction operates on an LRU policy.
#      https://github.community/t/github-actions-cache-eviction-policy/143754/3
#
# Together, these factors imply that if you make multiple pushes to a feature
# branch, such as when fixing bugs, GitHub will evict the older caches,
# including that for the default branch. The problem with this is that
# if there is a new separate feature branch, or a test-on-merge operation,
# those will get cache misses, causing a 20 min CI time.
#
# The solution to this to "pin" at least one cache entry for the default branch.
# So if there is only one cache entry for the default branch, we manually evict
# a cache entry from a non-default branch (on an LRU basis). That should create
# enough space for a new cache entry.

from datetime import datetime
import requests
import operator
import os

DEFAULT_BRANCH_NAME = 'scip-ruby/master'

CACHES_URL = 'https://api.github.com/repos/sourcegraph/scip-ruby/actions/caches'

# 10 GB limit: https://github.com/actions/cache#cache-limits
GITHUB_CACHE_LIMIT_BYTES = 10_000_000_000

def partition(xs, f):
    good = [x for x in xs if f(x)]
    bad = [x for x in xs if not f(x)]
    return (good, bad)

def default_main():
    access_token = os.environ['ACCESS_TOKEN']
    headers = {
        'Accept': 'application/vnd.github.v3+json',
        'Authorization': 'token {}'.format(access_token)
    }
    caches = requests.get(CACHES_URL, headers=headers).json()
    if caches['total_count'] == 0:
        print('GitHub Actions cache is empty.')
        print('Not manually evicting any entry.')
        return

    sizes = [x['size_in_bytes'] for x in caches['actions_caches']]
    avg_size = sum(sizes) / len(sizes)
    if avg_size + sum(sizes) < 0.90 * GITHUB_CACHE_LIMIT_BYTES:
        # Don't evict anything, we'll probably be fine.
        print('Remaining space in cache {:.2f} GB'.format(sum(sizes) / 1_000_000_000))
        print('Not manually evicting any entry.')
        return

    default_branch_cache_entries, other_branch_cache_entries = partition(
        caches['actions_caches'],
        lambda x: x['ref'].endswith(DEFAULT_BRANCH_NAME)
    )
    if len(default_branch_cache_entries) > 1:
        # Even if the cache action decides to evict a cache entry
        # for the default branch, it'll be OK, since we'll at least have
        # one cache entry left. This is assuming that we don't have a ginormous
        # cache entry, but that's OK.
        print('Found multiple cache entries for {}'.format(DEFAULT_BRANCH_NAME))
        print('Not manually evicting any entry.')
        return

    if len(other_branch_cache_entries) == 0:
        print('Expected 1+ cache entries for non-default branches but found 0.')
        print('Normally, this should be impossible. :thinking_face:')
        return

    entries_and_times = [
        (x, datetime.strptime(x['last_accessed_at'].split('.')[0], '%Y-%m-%dT%H:%M:%S'))
        for x in other_branch_cache_entries
    ]

    # Sort descending based on timestamps, and evict the oldest two.
    sorted(entries_and_times, key=operator.itemgetter(1))
    earliest_entries = [x[0] for x in entries_and_times[0:2]]

    for early_entry in earliest_entries:
       if os.getenv('DRY_RUN'):
           print('dry run: Will evict:\n{}'.format(early_entry))
           continue

       print('requesting deletion of cache entry:\n{}'.format(early_entry))

       entry_url = '{}/{}'.format(CACHES_URL, early_entry['id'])

       res = requests.delete(entry_url, headers=headers)
       print('cache deletion status: {}', res.status_code)

if __name__ == '__main__':
    default_main()
