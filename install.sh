#!/bin/bash

for f in .bash_completions .bashrc_public .hgrc .screenrc .vim .vimrc
do
    cp -irp $f ~
done

touch ~/.vimrc_private

echo -e "\nsource ~/.bashrc_public" >> ~/.bashrc
echo -e "\nsource ~/.bashrc_private" >> ~/.bashrc

touch ~/.bashrc_private
chmod 600 ~/.bashrc_private

mkdir -p ~/bin/
cp -r bin/* ~/bin/
