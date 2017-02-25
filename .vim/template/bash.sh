#!/bin/bash

#--------------------------------------------------------------------
# Global configurations.
#--------------------------------------------------------------------

cd $(dirname $0)
readonly ROOT=$(pwd)
readonly TMP=${TMPDIR:-/tmp}/$(basename $0).tmp.$$

#--------------------------------------------------------------------
# Helper functions.
#--------------------------------------------------------------------

usage()
{
  cat << EOF
  usage: $0 [options]

  OPTIONS:
  -h      Show this message.
EOF
}

clean_up()
{
  rm -f $TMP > /dev/null 2>&1
}

# echo colorful texts.
# $1: 0-7, the color code.
# $2: the text.
cecho()
{
  echo -e "\n\03$1[1;33m$2\033[m"
}

run()
{
  cecho 3 "> Run $@"
  echo
  eval time $@  # Must use eval to process single quote.
}

main()
{
  # Parse arguments.
  while getopts "h" OPTION
  do
    case $OPTION in
      h)
        usage
        exit 1
        ;;
      ?)
        usage
        exit 2
        ;;
    esac
  done

  # Keep the rest arguments in $@.
  shift $((OPTIND-1))

  # Main.
  # TODO
}

#--------------------------------------------------------------------

# Clean up when receiving signals (including Ctrl+C).
trap "clean_up; exit 1" 1 2 3 13 15

main $@

clean_up
exit 0
