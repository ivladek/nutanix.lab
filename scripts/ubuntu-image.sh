#!/bin/bash

PCaddress="10.1.8.70"
VMdata="ubuntu-image.json"

# import NTNXuser, NTNXpassword
source secrets.sh
NTNX_pc_login="https://${PCaddress}:9440/PrismGateway/services/rest/v3/cluster"
NTNX_create_vm="https://${PCaddress}:9440/api/nutanix/v3/vms"
PClogin=$(echo "${NTNXuser}:${NTNXpassword}" | tr -d '[:space:]' | openssl base64 | tr -d '[:space:]')
NTNXcoockie="pc_${PCaddress}_login-data.bin"

rm -f "${NTNXcoockie}"
curl \
  -k "${NTNX_pc_login}" \
  -u "${NTNXuser}:${NTNXpassword}" \
  -c "${NTNXcoockie}" \
  -X "GET" \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic ${PClogin}"
curl \
  -k "${NTNX_create_vm}" \
  -b "${NTNXcoockie}" \
  -X "POST" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -d "@${VMdata}"
rm -f "${NTNXcoockie}"
