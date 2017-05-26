#!/usr/bin/env python
# -*- encoding: utf8 -*-

import subprocess
import sys
import optparse
import os

DEBUG = False


def red(text):
    if sys.stdout.isatty():
        return '\033[1;31m%s\033[0m' % text
    else:
        return text

def green(text):
    if sys.stdout.isatty():
        return '\033[1;32m%s\033[0m' % text
    else:
        return text

def yellow(text):
    if sys.stdout.isatty():
        return '\033[1;33m%s\033[0m' % text
    else:
        return text

def highlight(text, symbol):
    if not symbol:
        return text
    # Find all begin indexes of case-insensitive substring.
    begins = []
    base = 0
    symbol = symbol.lower()
    lower_text = text.lower()
    while True:
        try:
            offset = lower_text.index(symbol)
            begins.append(base + offset)
            lower_text = lower_text[offset + len(symbol):]
            base += offset + len(symbol)
        except Exception as e:
            break

    if not begins:
        return text

    # Highlight matched case-insensitive substrings.
    result = []
    last_end = 0
    for begin in begins:
        if begin > last_end:
            result.append(text[last_end:begin])
        end = begin + len(symbol)
        result.append(red(text[begin:end]))
        last_end = end
    if last_end < len(text):
        result.append(text[last_end:])

    return ''.join(result)


def output(commit, path, symbols, lines):
    rows = None
    try:
        rows, _ = os.popen('stty size', 'r').read().split()
        rows = int(rows)
    except Exception as e:
        rows = None

    use_more = rows is not None
    for i, line in enumerate(lines):
        line = line.strip()
        line_num = '%s)' % (i + 1)
        begin = line.index(line_num)
        end = begin + len(line_num)
        line = ''.join((line[:begin], yellow(line[begin:end]), line[end:]))
        for s in symbols:
            line = highlight(line, s)
        print(line)
        if use_more and (i + 1) % (rows - 1) == 0:
            try:
                _ = raw_input('-- More (press ENTER to continue / Ctrl+C or D to end) --')
            except (EOFError, KeyboardInterrupt) as _:
                use_more = False
    msg = green('\n>>> Result of %s %s' % (commit, path))
    print(msg)

def blame(commit, path, symbols):
    history = []
    while True:
        cmd = 'git blame -C %s -- %s' % (commit, path)
        history.append(cmd)
        if DEBUG:
            sys.stderr.write('DEBUG: %s\n' % cmd)
        p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
        lines = [line.strip() for line in p.stdout.readlines()]
        output(commit, path, symbols, lines)
        while True:
            try:
                response = raw_input('\ninput the line number to continue blame ( press Ctrl+C or D to exit)> ').strip()
            except (EOFError, KeyboardInterrupt) as _:
                print('')
                n = None
                break
            try:
                n = int(response)
                break
            except Exception as _:
                pass
        if n is None:
            break


        # The user input range: 1 .. len(lines).
        if n <= 0 or n > len(lines):
            break
        line = lines[n - 1]
        tokens = line.split()
        commit = tokens[0] + '~'
        path = tokens[1]

    print(green('\n>>> History:\n'))
    for cmd in history:
        print(cmd)
    print('')


def main():
    '''\
    %prog [options] [commit] <path>
    '''
    parser = optparse.OptionParser(usage=main.__doc__)
    parser.add_option('-s', '--symbol', dest='symbols',
                      type='string', default='',
                      help=('Highlight the matched <symbol>. '
                            'You can assign multiple symbols separated by commas.'))
    options, args = parser.parse_args()

    if not (len(args) >= 1 and len(args) <= 2):
        parser.print_help()
        return 1

    if len(args) == 1:
        commit = 'HEAD'
        path = args[0]
    else:
        commit, path = args
    symbols = []
    if options.symbols:
        symbols = options.symbols.split(',')
    blame(commit, path, symbols)

    return 0

if __name__ == '__main__':
    sys.exit(main())
