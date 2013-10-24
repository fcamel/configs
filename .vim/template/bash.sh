#!/bin/bash

#--------------------------------------------------------------------
# Helper functions
#--------------------------------------------------------------------

usage()
{
  cat << EOF
  usage: $0 [options]

  OPTIONS:
  -h      Show this message.
EOF
}

run()
{
  echo -e "\n\033[1;33m> Run $@\033[m\n"
  eval time $@  # Must use eval to process single quote.
}

#--------------------------------------------------------------------
# Parse arguments.
#--------------------------------------------------------------------

while getopts “h” OPTION
do
  case $OPTION in
    h)
      usage
      exit 1
      ;;
    ?)
      usage
      exit
      ;;
  esac
done


#--------------------------------------------------------------------
# Main
#--------------------------------------------------------------------

cd $(dirname $0)

