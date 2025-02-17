#!/usr/bin/env python3

import sys
from passlib.hash import sha512_crypt

print(sha512_crypt.hash(sys.argv[1], rounds=4096))
