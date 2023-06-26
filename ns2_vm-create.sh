#!/bin/bash

PCaddress="10.1.8.70"
VMdata="ns2_vm-data_api-v3.json"

# import NTNXuser, NTNXpassword
source secrets.sh
NTNX_pc_login="https://${PCaddress}:9440/PrismGateway/services/rest/v3/cluster"
NTNX_create_vm="https://${PCaddress}:9440/api/nutanix/v3/vms"
NTNX_coockie="ntnx-login-data.bin"
PClogin=$(echo "${NTNXuser}:${NTNXpassword}" | tr -d '[:space:]' | openssl base64 | tr -d '[:space:]')

rm -f "${NTNX_coockie}"
curl \
  -k "${NTNX_pc_login}" \
  -u "${NTNXuser}:${NTNXpassword}" \
  -c "${NTNX_coockie}" \
  -X "GET" \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic ${PClogin}"
curl \
  -k "${NTNX_create_vm}" \
  -b "${NTNX_coockie}" \
  -X "POST" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -d "@${VMdata}"
rm -f "${NTNX_coockie}"
