#!/usr/bin/env python
# -*- encoding: utf8 -*-

import re
import subprocess
import sys
import optparse

class Match(object):
    def __init__(self, tokens, pattern):
        self.filename, self.line_num, self.text = tokens
        self.line_num = int(self.line_num)
        self.column = self.text.index(pattern)

    @staticmethod
    def create(line, pattern):
        tokens = line.split(':', 2)
        if len(tokens) != 3:
            return None
        return Match(tokens, pattern)

    def __unicode__(self):
        tokens = [self.filename, self.line_num, self.column, self.text]
        return u':'.join(map(str, tokens))

    def __str__(self):
        return str(unicode(self))

def _gid(pattern):
    cmd = ['gid', pattern]
    process = subprocess.Popen(cmd,
                               stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE)
    return process.stdout.read().split('\n')

def _filter_pattern(matches, pattern):
    return [m for m in matches
            if re.search('\\b%s\\b' % pattern, m.text)]

def get_list(patterns=None):
    if patterns is None:
        patterns = get_list.original_patterns
    first_pattern = patterns[0]

    lines = _gid(first_pattern)
    matches = [Match.create(line, first_pattern) for line in lines]
    matches = [m for m in matches if m]

    for pattern in patterns[1:]:
        matches = _filter_pattern(matches, pattern)

    return matches

def main():
    '''\
    %prog [options] <pattern> [<pattern> ...]
    '''
    parser = optparse.OptionParser(usage=main.__doc__)
    options, args = parser.parse_args()

    if len(args) < 1:
        parser.print_help()
        return 1

    matches = get_list(args)
    for m in matches:
        print unicode(m).encode('utf8')

    return 0


if __name__ == '__main__':
    sys.exit(main())
