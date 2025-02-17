#!/bin/bash

GITuser="ivladek"
GITserver="github.com"
GITemail="vladek@me.com"

GITrepo="nutanix.lab"
GITbranch="2025.02.17"
GITssh="ssh"

git init -q
git config user.name       "${GITuser}"
git config user.email      "${GITemail}"
git config core.sshCommand "${GITssh}"
git remote add -f -t ${GITbranch} origin "git@${GITserver}:${GITuser}/${GITrepo}.git"
