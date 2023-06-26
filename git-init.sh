#!/bin/bash

# import GITemail & GITkey
source secrets.sh

GITuser="ivladek"
GITserver="github.com"
GITrepo="nutanix.lab"
GITbranch="marvel.2023"
GITssh="ssh -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ServerAliveInterval=30 -o ServerAliveCountMax=5 -i ${GITkey}"

git init -q
git config user.name       "${GITuser}"
git config user.email      "${GITemail}"
git config core.sshCommand "${GITssh}"
git remote add -f -t ${GITbranch} origin "git@${GITserver}:${GITuser}/${GITrepo}.git"
