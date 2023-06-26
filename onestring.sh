#!/bin/bash

rm -f "${2}"
IFS=''
while read -r line
do
  line="${line//\"/\\\"}"
  line="${line//\//\\/}"
  echo -n "${line}" >> "${2}"
  echo -n '\n' >> "${2}"
done < "${1}"