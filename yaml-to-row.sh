#!/bin/bash

INfile="${1}"
OUTfile="$(basename ${1}).txt"

rm -f "${OUTfile}"
IFS=''
while read -r line
do
  line="${line//\"/\\\"}"
  line="${line//\//\\/}"
  echo -n "${line}" >> "${OUTfile}"
  echo -n '\n' >> "${OUTfile}"
done < "${INfile}"