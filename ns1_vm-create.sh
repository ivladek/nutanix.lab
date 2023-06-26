#!/bin/bash

PEaddress="10.1.8.60"
VMdata="ns1_vm-data_api-v2.json"

# import NTNXuser, NTNXpassword
source secrets.sh
NTNX_create_vm="https://${PEaddress}:9440/api/nutanix/v2.0/vms"

curl \
  -k "${NTNX_create_vm}" \
  -u "${NTNXuser}:${NTNXpassword}" \
  -X "POST" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -d "@${VMdata}"
