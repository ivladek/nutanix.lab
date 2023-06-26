#!/bin/bash

PCaddress="10.1.8.60"
PCuser="admin"
PCpasswd="Marvel@2023"
PClogin=$(echo "$PCuser:$PCpasswd" | tr -d '[:space:]' | openssl base64 | tr -d '[:space:]')
PCurl_login="'https://$PCaddress:9440/PrismGateway/services/rest/v3/cluster'"
PCurl_vmcreate="'https://$PCaddress:9440/api/nutanix/v3/vms'"
PCheader_auth="'Authorization: Basic $PClogin'"
PCcookie="pc-data.cookie"
PCreq_vmcreate="'$(cat ns1_vm-data.json)'"

curl -c $PCcookie -X 'GET'  -k $PCurl_login    -H 'Content-Type: application/json' -H $PCheader_auth
curl -b $PCcookie -X 'POST' -k $PCurl_vmcreate -H 'accept: application/json' -H 'Content-Type: application/json' -d $PCreq_vmcreate
