PLAN
 - VLANs + IP Subnets
 - Internet connection
 - admin station - VM or notebook
 - resources Foundation VM

 PREPARATION
 - switches - ports, NTP
 - IPMI - IP Address, uEFI, NTP (!!!), power off
 - foundation VM - download and deploy (Virtual Box or VMware Workstation Player)
 - download AOS image

DEPLOY CLUSTER
 - Use foundation VM Web UI
 - change passwords - login to any CVM:
   - nutanix on cluster:  echo "nutanix:Nutanix@2023" | sudo chpasswd
   - root on AHV:         allssh "ssh root@192.168.5.1 'echo \"root:Nutanix@2023\" | chpasswd'"
   - nutanix on AHV:      allssh "ssh root@192.168.5.1 'echo \"nutanix:Nutanix@2023\" | chpasswd'"

POST DEPLOY CLUSTER
 - iSCSI data IP - set
 - LCM - update everything
 - Virtual switch - MTU, uplinks
 - Networks segments - create with and without IPAM

DEPLOY DNS 1 using PE
 - Upload Ubuntu cloud image to the cluster
 - adopt YAMLs and JSONs to environment
    - get vdisk uuid for uploaded image
      - image uuid for API v3: acli image.list
      - vdisk uuid for API v2: acli image.get <image uuid>
    - get net uuid: acli net.list
    - get cluster uuid: ncli cluster info
    - convert user-data to:
      - one line    for API v2: ./yaml-to-row.sh ns1_user-data.yaml
        - copy line from ns1_user-data.yaml.txt to ns1_vm-data_api-v2.json
      - base64 line for API v3: ./yaml-to-b64.sh ns2_user-data.yaml
        - copy line from ns2_user-data.yaml.txt to ns1_vm-data_api-v3.json
 - copy scripts to CVM1 to ~/tmp
 - deploy ns1 using Rest API: ./ns2_vm-create.sh

POST DEPLOY CLUSTER
 - set cluster fqdn

DEPLOY PC
 - download 1-click deploy PC from PE image
 - upload tar & json to cvm1 to /home/nutanix/tmp
 - add to PC -  ncli software upload file-path=/home/nutanix/tmp/zakroma/pc.2023.1.0.2.tar meta-file-path=/home/nutanix/tmp/zakroma/generated-pc.2023.1.0.2-metadata.json  software-type=PRISM_CENTRAL_DEPLOY
 - Deploy PC
 - Login to PC and set fqdn
 - connect PE to PC
 - LCM on PC and PE
 - change passwords - login to any PCVM: echo "nutanix:Nutanix@2023" | sudo chpasswd
 - import images to PC


DEPLOY DNS 2 using PC
 - Upload Ubuntu cloud image to the cluster
 - get vdisk uuid for uploaded image
 - adopt YAMLs and JSONs to environment
 - deploy ns2 using Rest API
