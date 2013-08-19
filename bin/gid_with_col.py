#!/usr/bin/env python
# -*- encoding: utf8 -*-

import re
import subprocess
import sys
import optparse
import platform

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
        return u':'.join(map(unicode, tokens))

    def __str__(self):
        return str(unicode(self))

def _gid(pattern):
    gid = 'gid'
    if platform.system() == 'Darwin':
        gid = 'gid32'
    cmd = [gid, pattern]
    process = subprocess.Popen(cmd,
                               stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE)
    return [line.decode('utf8')
            for line in process.stdout.read().split('\n')]

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

def _diff_list(kept, removed):
    return [e for e in kept if e not in removed]

def _filter_statement(all_, exclude):
    matches = [m for m in all_ if re.search(';\s*$', m.text)]
    if not exclude:
        return matches
    return _diff_list(all_, matches)

def _filter_filename(all_, pattern, exclude):
    matched = [m for m in all_ if re.search(pattern, m.filename)]
    if not exclude:
        return matched
    return _diff_list(all_, matched)

def _keep_definition(all_, pattern):
    new_pattern = ':%s(' % pattern
    return [m for m in all_ if new_pattern in m.text]


def find_declaration_or_definition(pattern):
    if pattern.startswith('m_') or pattern.startswith('s_'):
        # For non-static member fields or static member fields,
        # find symobls in header files.
        matches = get_list([pattern])
        return _filter_filename(matches, '\.h$', False)

    # Find declaration if possible.
    result = []
    matches = get_list([pattern, 'class'])
    matches = _filter_statement(matches, True)
    result += matches
    result += get_list([pattern, 'typedef'])
    result += get_list([pattern, 'define'])
    # Find definition if possible.
    matches = _keep_definition(get_list([pattern]), pattern)
    result += matches
    return result

def main():
    '''\
    %prog [options] <pattern> [<pattern> ...]
    '''
    parser = optparse.OptionParser(usage=main.__doc__)
    parser.add_option('-d', '--declaration', dest='declaration', action='store_true', default=False,
                      help='Find possible declarations.')
    options, args = parser.parse_args()

    if len(args) < 1:
        parser.print_help()
        return 1

    if options.declaration:
        matches = find_declaration_or_definition(args[0])
    else:
        matches = get_list(args)
    for m in matches:
        print unicode(m).encode('utf8')

    return 0


if __name__ == '__main__':
    sys.exit(main())
