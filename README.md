 PREPARATION
 - switches - ports, NTP
 - IPMI - IP Address, uEFI, NTP (!!!), power off
 - foundation VM - download and deploy (Virtual Box or VMware Workstation Player)
 - download AOS image

DEPLOY CLUSTER
 - Use foundation VM Web UI

DEPLOY DNS 1 using PE
 - Upload Ubuntu cloud image to the cluster
 - get vdisk uuid for uploaded image
 - adopt YAMLs and JSONs to environment
 - deploy ns1 using Rest API

POST DEPLOY CLUSTER
 - iSCSI data IP - set
 - LCM - update everything
 - Virtual switch - MTU, uplinks
 - Networks segments - create with and without IPAM
 - set cluster fqdn

DEPLOY PC
 - download 1-click deploy PC from PE image
 - upload tar & json to cvm1 to /home/nutanix/tmp
 - add to PC -  ncli software upload file-path=/home/nutanix/tmp/pc.2023.1.0.1.tar meta-file-path=/home/nutanix/tmp/generated-pc.2023.1.0.1-metadata.json  software-type=PRISM_CENTRAL_DEPLOY
 - Deploy PC
 - Login to PC and set fqdn
 - connect PE to PC
 - LCM on PC and PE


DEPLOY DNS 2 using PC
 - Upload Ubuntu cloud image to the cluster
 - get vdisk uuid for uploaded image
 - adopt YAMLs and JSONs to environment
 - deploy ns1 using Rest API
