#!/bin/bash

cd $(dirname $0)

for f in $@
do
  vimdiff $f ~/$f
done
