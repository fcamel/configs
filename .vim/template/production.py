#!/usr/bin/env python2.5
# -*- encoding: utf8 -*-

import sys
import optparse

def main(args):
    '''\
    %prog [options]
    '''
    return 0


if __name__ == '__main__':
    parser = optparse.OptionParser(usage=main.__doc__)
    options, args = parser.parse_args()

    sys.exit(main(args))
