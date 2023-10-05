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
  - admin on CLUSTER:    sudo chage -M 1000 admin

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
  - add to PC -  ncli software upload file-path=/home/nutanix/tmp/zakroma/pc.2023.3.tar meta-file-path=/home/nutanix/tmp/zakroma/generated-pc.2023.3-metadata.json  software-type=PRISM_CENTRAL_DEPLOY
  - Deploy PC
  - Login to PC and set fqdn
  - connect PE to PC
  - LCM on PC and PE
  - change passwords - login to any PCVM: echo "nutanix:Nutanix@2023" | sudo chpasswd
  - admin on PC: sudo chage -M 1000 admin
  - import images to PC


DEPLOY DNS 2 using PC
  - Upload Ubuntu cloud image to the cluster
  - get vdisk uuid for uploaded image
  - adopt YAMLs and JSONs to environment
  - deploy ns2 using Rest API

DEPLOY LDAP (DC)
  - %WINDIR%\system32\sysprep\sysprep.exe /generalize /oobe /mode:vm /shutdown
 

PREPARE WINDOWS IMAGE
  - VM: 1 vCore, 4 GB RAM, 40 GB HDD, 2 CD-ROM (Windows ISO, VirtIO ISO), 1 Serial, 1 NIC
  - Install Windows Server 2019 using Nutanix VirtIO
  - Install Nutanix Guest Tools
  - Disable IESC, UAC:
    - Computer Configuration / Policies / Windows Settings / Security Settings / Local Policies / Security Options / User Account Control:
      - Behavior of the elevation prompt for administrators in Admin Approval Mode: Elevate without prompting
      - Detect application installations and prompt for elevation: Disabled
      - Run all administrators in Admin Approval Mode: Disabled
      - Only elevate UIAccess applications that are installed in secure locations: Disabled
  - Enable RDP
  - Tune PowerShell:
    - Set-ExecutionPolicy Unrestricted
    - Enable-PSRemoting
  - Enable WinRM listener using GPO:
    - Computer Configuration / Administrative Templates / Windows Components / Windows Remote Management (WinRM) / WinRM Service / Allow remote service management through WinRM: Enabled */*
  - Install Python from https://www.python.org/downloads/windows/
  - firewall:
    - enable: ping, rdp
    - disable: NBT 
  - Prepare: C:\Windows\system32\sysprep\sysprep.exe /generalize /oobe /mode:vm /shutdown
 