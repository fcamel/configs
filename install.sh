#!/bin/bash

for f in .bash_completions .bashrc_public .hgrc .screenrc .vim .vimrc
do
    cp -irp $f ~
done

echo -e "\nsource ~/.bashrc_public" >> ~/.bashrc
