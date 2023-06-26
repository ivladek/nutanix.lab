#!/bin/bash

INfile="${1}"
OUTfile="$(basename ${1}).txt"

openssl base64 -in ${INfile} | tr -d '[:space:]' > ${OUTfile}
